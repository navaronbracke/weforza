
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideExportState.dart';

class ExportRideBloc extends Bloc {
  ExportRideBloc({
    @required this.ride,
    @required this.loadedAttendees,
    @required this.fileHandler,
    @required this.filename,
  }): assert(ride != null && loadedAttendees != null
      && fileHandler != null
      && filename != null && filename.isNotEmpty) {
    fileNameController = TextEditingController(text: filename);
  }

  final IFileHandler fileHandler;
  final Ride ride;
  final Future<List<Member>> loadedAttendees;
  final RegExp filenamePattern = RegExp(r"^[\w\s-]{1,80}$");
  final int filenameMaxLength = 80;
  TextEditingController fileNameController;

  final StreamController<RideExportState> _streamController = BehaviorSubject();
  Stream<RideExportState> get stream => _streamController.stream;

  final StreamController<String> _fileNameErrorController = BehaviorSubject();
  Stream<String> get fileNameErrorStream => _fileNameErrorController.stream;

  List<Member> rideAttendees;

  bool autoValidateFileName = false;

  String filename;

  FileExtension _fileExtension = FileExtension.CSV;

  void onSelectFileExtension(FileExtension extension){
    if(_fileExtension != extension){
      _fileNameErrorController.add("");
      _fileExtension = extension;
    }
  }

  ///Form Error message
  String filenameError;

  void loadRideAttendees() async {
    _streamController.add(RideExportState.INIT);
    rideAttendees =  await loadedAttendees;//These are already loaded!
    _streamController.add(RideExportState.IDLE);
  }

  String validateFileName(
      String value,
      String fileNameIsRequired,
      String isWhitespaceMessage,
      String filenameNameMaxLengthMessage,
      String invalidFilenameMessage)
  {
    if(filename != value){
      _fileNameErrorController.add("");
    }

    if(value == null || value.isEmpty){
      filenameError = fileNameIsRequired;
    }else if(value.trim().isEmpty){
      filenameError = isWhitespaceMessage;
    }else if(filenameMaxLength < value.length){
      //The full title is the biggest thing we allow
      filenameError = filenameNameMaxLengthMessage;
    }else if(!filenamePattern.hasMatch(value)){
      filenameError = invalidFilenameMessage;
    }else{
      filename = value;
      filenameError = null;
    }

    return filenameError;
  }

  void exportRide(String fileExistsMessage) async {
    await fileHandler.createFile(filename, _fileExtension.extension()).then((file) async {
      if(await file.exists()){
        _fileNameErrorController.add(fileExistsMessage);
      }else{
        _fileNameErrorController.add("");
        _streamController.add(RideExportState.EXPORTING);
        await _saveRideAndAttendeesToFile(file, _fileExtension.extension(), ride, rideAttendees);
        _streamController.add(RideExportState.DONE);
      }
    }).catchError((e) => _streamController.addError(e));
  }

  ///Save the given ride and attendees to the given file.
  ///The extension determines how the data is structured inside the file.
  Future<void> _saveRideAndAttendeesToFile(File file, String extension, Ride ride, List<Member> attendees) async {
    if(extension == FileExtension.CSV.extension()){
      final buffer = StringBuffer();
      buffer.writeln(ride.toCsv());
      for(Member m in attendees){
        buffer.writeln(m.toCsv());
      }
      await file.writeAsString(buffer.toString());
    }else if(extension == FileExtension.JSON.extension()){
      final data = {
        "details": ride.toJson(),
        "attendees": attendees.map((a) => a.toJson()).toList()
      };
      await file.writeAsString(jsonEncode(data));
    }else{
      return Future.error(InvalidFileExtensionError());
    }
  }

  @override
  void dispose() {
    _streamController.close();
    _fileNameErrorController.close();
    fileNameController.dispose();
  }
}