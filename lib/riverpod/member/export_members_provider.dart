import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/model/exportable_member.dart';
import 'package:weforza/repository/export_members_repository.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/repository/export_members_repository_provider.dart';

final exportMembersProvider = Provider((ref) {
  return ExportMembersProvider(
    ref.read(fileHandlerProvider),
    ref.read(exportMembersRepositoryProvider),
  );
});

class ExportMembersProvider {
  ExportMembersProvider(this.fileHandler, this.memberRepository);

  final FileHandler fileHandler;

  final ExportMembersRepository memberRepository;

  /// Save the given [ExportableMember]s to the given file,
  /// using a write algorithm compatible with the given extension.
  /// In case of CSV files, the [csvHeader] is used as first line.
  Future<void> _saveMembersToFile(
    File file,
    String extension,
    Iterable<ExportableMember> members,
    String csvHeader,
  ) async {
    if (extension == FileExtension.csv.ext) {
      final buffer = StringBuffer();

      buffer.writeln(csvHeader);

      for (final exportedMember in members) {
        buffer.writeln(exportedMember.toCsv());
      }

      await file.writeAsString(buffer.toString());

      return;
    }

    if (extension == FileExtension.json.ext) {
      final Map<String, dynamic> data = {
        'riders': members.map((member) => member.toJson()).toList()
      };

      await file.writeAsString(jsonEncode(data));

      return;
    }

    return Future.error(InvalidFileExtensionError());
  }

  Future<void> exportMembers({
    required String csvHeader,
    required String fileExtension,
    required String fileName,
  }) async {
    final file = await fileHandler.createFile(fileName, fileExtension);

    if (await file.exists()) {
      return Future.error(FileExistsException());
    }

    final exports = await memberRepository.getMembers();

    await _saveMembersToFile(file, fileExtension, exports, csvHeader);
  }
}
