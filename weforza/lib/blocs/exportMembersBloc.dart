
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/exportableMember.dart';
import 'package:weforza/repository/exportMembersRepository.dart';

class ExportMembersBloc extends Bloc {
  ExportMembersBloc({
    @required this.exportMembersRepository,
    @required this.fileHandler
  }): assert(exportMembersRepository != null && fileHandler != null);

  final ExportMembersRepository exportMembersRepository;
  final IFileHandler fileHandler;

  final StreamController<MembersExportState> _streamController = BehaviorSubject();
  Stream<MembersExportState> get stream => _streamController.stream;

  final StreamController<bool> _fileExistsController = BehaviorSubject();
  Stream<bool> get fileExistsStream => _fileExistsController.stream;

  final RegExp filenamePattern = RegExp(r"^[\w\s-]{1,80}$");
  final TextEditingController filenameController = TextEditingController();

  bool autoValidateFileName = false;

  final int filenameMaxLength = 80;
  String _filename;

  FileExtension _fileExtension = FileExtension.CSV;

  void onSelectFileExtension(FileExtension extension) => _fileExtension = extension;

  ///Form Error message
  String filenameError;

  String validateFileName(
      String filename,
      String fileNameIsRequired,
      String isWhitespaceMessage,
      String filenameNameMaxLengthMessage,
      String invalidFilenameMessage)
  {
    if(filename == null || filename.isEmpty){
      filenameError = fileNameIsRequired;
    }else if(filename.trim().isEmpty){
      filenameError = isWhitespaceMessage;
    }else if(filenameMaxLength < filename.length){
      filenameError = filenameNameMaxLengthMessage;
    }else if(!filenamePattern.hasMatch(filename)){
      filenameError = invalidFilenameMessage;
    }else{
      _filename = filename;
      filenameError = null;
    }

    return filenameError;
  }

  Future<void> exportMembers(String csvHeader) async {
    await fileHandler.createFile(_filename, _fileExtension.extension()).then((file) async {
      if(await file.exists()){
        _fileExistsController.add(true);
      }else{
        _fileExistsController.add(false);
        _streamController.add(MembersExportState.EXPORTING);
        final Iterable<ExportableMember> exports = await exportMembersRepository.getMembers();
        await _saveMembersToFile(file, _fileExtension.extension(), exports, csvHeader);
        _streamController.add(MembersExportState.DONE);
      }
    }).catchError((e) => _streamController.addError(e));
  }

  /// Save the given [ExportableMember]s to the given file,
  /// using a write algorithm compatible with the given extension.
  /// In case of CSV files, the [csvHeader] is used as first line.
  Future<void> _saveMembersToFile(File file, String extension, Iterable<ExportableMember> members, String csvHeader) async {
    if(extension == FileExtension.CSV.extension()){
      final buffer = StringBuffer();

      buffer.writeln(csvHeader);

      members.forEach((exportedMember) {
        buffer.writeln(exportedMember.toCsv());
      });

      await file.writeAsString(buffer.toString());
    }else if(extension == FileExtension.JSON.extension()){
      final Map<String, dynamic> data = {
        "members": members.map((ExportableMember member) => member.toJson()).toList()
      };

      await file.writeAsString(jsonEncode(data));
    }else{
      return Future.error(InvalidFileFormatError());
    }
  }

  @override
  void dispose() {
    filenameController.dispose();
    _fileExistsController.close();
    _streamController.close();
  }
}

enum MembersExportState {
  IDLE,
  EXPORTING,
  DONE
}