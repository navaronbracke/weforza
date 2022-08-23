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
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/repository/import_members_repository_provider.dart';

final importMembersProvider = Provider(ImportMembersNotifier.new);

class ImportMembersNotifier {
  ImportMembersNotifier(this.ref);

  final Ref ref;

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
    if (file.path.endsWith(FileExtension.csv.ext)) {
      return _readFile<String>(
        file,
        CsvFileReader(headerRegex: csvHeaderRegex),
      );
    }

    if (file.path.endsWith(FileExtension.json.ext)) {
      return _readFile<Map<String, dynamic>>(file, JsonFileReader());
    }

    return Future.error(InvalidFileExtensionError());
  }

  void importMembers(
    String headerRegex,
    void Function(ImportMembersState progress) onProgress,
    void Function(Object error) onError,
  ) async {
    try {
      onProgress(ImportMembersState.pickingFile);

      final fileHandler = ref.read(fileHandlerProvider);

      final file = await fileHandler.chooseImportMemberDatasourceFile();

      onProgress(ImportMembersState.importing);

      final members = await _readMemberDataFromFile(file, headerRegex);

      if (members.isEmpty) {
        onProgress(ImportMembersState.done);

        return;
      }

      const uuidGenerator = Uuid();

      final repository = ref.read(importMembersRepositoryProvider);

      await repository.saveMembersWithDevices(members, uuidGenerator.v4);

      ref.refresh(memberListProvider);
      onProgress(ImportMembersState.done);
    } catch (error) {
      onError(error);
    }
  }
}
