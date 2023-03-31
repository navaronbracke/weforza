import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/exportableRide.dart';
import 'package:weforza/model/rideExportState.dart';
import 'package:weforza/repository/exportRidesRepository.dart';

class ExportRidesBloc extends Bloc {
  ExportRidesBloc({
    @required this.repository,
    @required this.fileHandler,
  });

  final ExportRidesRepository repository;
  final IFileHandler fileHandler;
  final TextEditingController fileNameController = TextEditingController();
  final RegExp filenamePattern = RegExp(r"^[\w\s-]{1,80}$");

  final StreamController<RideExportState> _submitController = BehaviorSubject();
  Stream<RideExportState> get submitStream => _submitController.stream;

  final StreamController<bool> _fileExistsController = BehaviorSubject();
  Stream<bool> get fileExistsStream => _fileExistsController.stream;

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
      //The full title is the biggest thing we allow
      filenameError = filenameNameMaxLengthMessage;
    }else if(!filenamePattern.hasMatch(filename)){
      filenameError = invalidFilenameMessage;
    }else{
      _filename = filename;
      filenameError = null;
    }

    return filenameError;
  }

  Future<void> exportRidesWithAttendees() async {
    final Iterable<ExportableRide> rides = await repository.getRides();

    await fileHandler.createFile(_filename, _fileExtension.extension()).then((file) async {
      if(await file.exists()){
        _fileExistsController.add(true);
      }else{
        _fileExistsController.add(false);
        _submitController.add(RideExportState.EXPORTING);
        await _saveRidesToFile(file, _fileExtension.extension(), rides);
        _submitController.add(RideExportState.DONE);
      }
    }).catchError((e)=> _submitController.addError(e));
  }

  ///Save the given [ExportableRide]s to the given file.
  ///The extension determines how the data is structured inside the file.
  Future<void> _saveRidesToFile(File file, String extension, Iterable<ExportableRide> rides) async {
    if(extension == FileExtension.CSV.extension()){
      final buffer = StringBuffer();

      rides.forEach((exportedRide) {
        buffer.writeln(exportedRide.ride.toCsv());
        buffer.writeln();
        for(ExportableRideAttendee attendee in exportedRide.attendees){
          buffer.writeln(attendee.toCsv());
        }
        buffer.writeln();
      });

      await file.writeAsString(buffer.toString());
    }else if(extension == FileExtension.JSON.extension()){
      final Map<String, dynamic> data = {
        "rides": rides.map((ExportableRide exportableRide) => {
          "ride": exportableRide.ride.toJson(),
          "attendees": exportableRide.attendees.map((attendee) => attendee.toJson()).toList()
        }).toList()
      };

      await file.writeAsString(jsonEncode(data));
    }else{
      return Future.error(InvalidFileExtensionError());
    }
  }

  @override
  void dispose() {
    _submitController.close();
    _fileExistsController.close();
    fileNameController.dispose();
  }

}