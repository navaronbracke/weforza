import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/csv_file_reader.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/file/import_members_file_reader.dart';
import 'package:weforza/file/json_file_reader.dart';
import 'package:weforza/model/exportable_member.dart';
import 'package:weforza/model/import_riders_state.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/repository/import_members_repository_provider.dart';

final importRidersProvider = Provider(ImportRidersNotifier.new);

class ImportRidersNotifier {
  ImportRidersNotifier(this.ref);

  /// The CSV file header format for importing riders
  /// requires 6 mandatory cells in the following order:
  /// 1) first name
  /// 2) last name
  /// 3) alias (can be the empty string, but the cell needs to exist)
  /// 4) active
  /// 5) last updated
  /// 6) devices
  final int headerCellCount = 6;

  final Ref ref;

  /// Build a regex that validates if a given string has at least [cellCount]
  /// cells, denoted by the given [cellDelimiter].
  ///
  /// The resulting regex ignores anything after the last mandatory cell.
  /// The last mandatory cell is allowed to have a cell delimiter,
  /// but it can also be omitted.
  ///
  /// Returns a [RegExp] with the cell matching pattern.
  RegExp _buildRegex({required int cellCount, String cellDelimiter = ','}) {
    final sb = StringBuffer();

    // A single cell can contain unicode letters, dashes and hyphens.
    const cellMatcher = r'([\p{L}_-])+';

    sb.write('^'); // Match the start of the string.

    // Match each cell.
    for (int i = 0; i < cellCount; i++) {
      sb.write(cellMatcher);

      // Each cell, except the last, gets a cell delimiter.
      if (i != cellCount - 1) {
        sb.write(cellDelimiter);
      }
    }

    // Everything after the last mandatory cell is squashed into a wildcard.
    // Finally, match the end of the string.
    sb.write(r'(.*)$');

    return RegExp(sb.toString(), unicode: true);
  }

  Future<List<ExportableMember>> _readFile<T>(
    File file,
    ImportMembersFileReader<T> fileReader,
  ) async {
    final List<ExportableMember> exports = [];

    final List<T> objects = await fileReader.readFile(file);

    if (objects.isEmpty) {
      return exports;
    }

    // Process each item, skipping invalid items.
    await Future.wait(
      objects.map((element) => fileReader.processData(element, exports)),
    );

    return exports;
  }

  Future<Iterable<ExportableMember>> _readRiderDataFromFile(File file) {
    if (file.path.endsWith(FileExtension.csv.ext)) {
      return _readFile<String>(
        file,
        CsvFileReader(headerRegex: _buildRegex(cellCount: headerCellCount)),
      );
    }

    if (file.path.endsWith(FileExtension.json.ext)) {
      return _readFile<Map<String, dynamic>>(file, JsonFileReader());
    }

    return Future.error(InvalidFileExtensionError());
  }

  void importRiders(
    void Function(ImportRidersState progress) onProgress,
    void Function(Object error) onError,
  ) async {
    try {
      onProgress(ImportRidersState.pickingFile);

      final fileHandler = ref.read(fileHandlerProvider);

      final file = await fileHandler.chooseImportMemberDatasourceFile();

      onProgress(ImportRidersState.importing);

      final members = await _readRiderDataFromFile(file);

      if (members.isEmpty) {
        onProgress(ImportRidersState.done);

        return;
      }

      final repository = ref.read(importMembersRepositoryProvider);

      await repository.saveMembersWithDevices(members);

      ref.invalidate(memberListProvider);
      onProgress(ImportRidersState.done);
    } catch (error) {
      onError(error);
    }
  }
}
