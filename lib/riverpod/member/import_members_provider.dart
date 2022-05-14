import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/csv_file_reader.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/file/import_members_file_reader.dart';
import 'package:weforza/file/json_file_reader.dart';
import 'package:weforza/model/exportable_member.dart';
import 'package:weforza/model/import_members_state.dart';
import 'package:weforza/repository/import_members_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';

final importMembersProvider = Provider((ref) {
  return ImportMembersNotifier(
    ref.read(fileHandlerProvider),
    ref.read(memberListProvider.notifier),
    ImportMembersRepository(ref.read(importMembersDaoProvider)),
  );
});

class ImportMembersNotifier {
  ImportMembersNotifier(this.fileHandler, this.membersList, this.repository);

  final IFileHandler fileHandler;

  final MemberListNotifier membersList;

  final ImportMembersRepository repository;

  Future<List<ExportableMember>> _readFile<T>(
    File file,
    ImportMembersFileReader<T> fileReader,
  ) async {
    final List<ExportableMember> exports = [];

    final List<T> objects = await fileReader.readFile(file);

    if (objects.isEmpty) {
      return exports;
    }

    // Process each item, skipping invalid items, instead of throwing an error.
    await Future.wait(
      objects.map((element) => fileReader.processData(element, exports)),
    );

    return exports;
  }

  Future<Iterable<ExportableMember>> _readMemberDataFromFile(
    File file,
    String csvHeaderRegex,
  ) {
    if (file.path.endsWith(FileExtension.csv.extension())) {
      return _readFile<String>(
        file,
        CsvFileReader(headerRegex: csvHeaderRegex),
      );
    }

    if (file.path.endsWith(FileExtension.json.extension())) {
      return _readFile<Map<String, dynamic>>(file, JsonFileReader());
    }

    return Future.error(InvalidFileExtensionError());
  }

  Future<void> importMembers(
    String headerRegex,
    void Function(ImportMembersState) onProgress,
  ) async {
    onProgress(ImportMembersState.pickingFile);

    final file = await fileHandler.chooseImportMemberDatasourceFile();

    onProgress(ImportMembersState.importing);

    final members = await _readMemberDataFromFile(file, headerRegex);

    if (members.isEmpty) {
      onProgress(ImportMembersState.done);

      return;
    }

    const uuidGenerator = Uuid();

    await repository.saveMembersWithDevices(members, uuidGenerator.v4);

    membersList.getMembers(); // Trigger a reload of the members list.
    onProgress(ImportMembersState.done);
  }
}
