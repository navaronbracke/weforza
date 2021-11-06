
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/exportDataOrError.dart';
import 'package:weforza/model/exportableRide.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';

class ExportRideBloc extends Bloc {
  ExportRideBloc({
    required this.ride,
    required this.fileHandler,
    required this.filename,
    required this.rideRepository
  }): assert(filename.isNotEmpty) {
    fileNameController = TextEditingController(text: filename);
  }

  final RideRepository rideRepository;
  final IFileHandler fileHandler;
  final Ride ride;
  final RegExp filenamePattern = RegExp(r"^[\w\s-]{1,80}$");
  final int filenameMaxLength = 80;
  late TextEditingController fileNameController;

  final StreamController<ExportDataOrError> _streamController = BehaviorSubject();
  Stream<ExportDataOrError> get stream => _streamController.stream;

  final StreamController<bool> _filenameExistsController = BehaviorSubject();
  Stream<bool> get fileNameExistsStream => _filenameExistsController.stream;

  String filename = "";

  FileExtension _fileExtension = FileExtension.CSV;

  void onSelectFileExtension(FileExtension extension){
    if(_fileExtension != extension){
      _filenameExistsController.add(false);
      _fileExtension = extension;
    }
  }

  ///Form Error message
  String? filenameError;

  String? validateFileName(
      String? value,
      String fileNameIsRequired,
      String isWhitespaceMessage,
      String filenameNameMaxLengthMessage,
      String invalidFilenameMessage)
  {
    if(filename != value){
      _filenameExistsController.add(false);
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

  void exportRide() async {
    await fileHandler.createFile(filename, _fileExtension.extension()).then((file) async {
      if(await file.exists()){
        _filenameExistsController.add(true);
      }else{
        _filenameExistsController.add(false);
        _streamController.add(ExportDataOrError.exporting());

        await _saveRideAndAttendeesToFile(
            file,
            _fileExtension.extension(),
            ride,
            await rideRepository.getRideAttendees(ride.date)
        );
        _streamController.add(ExportDataOrError.success());
      }
    }).catchError((e){
      _streamController.addError(e);
    });
  }

  ///Save the given ride and attendees to the given file.
  ///The extension determines how the data is structured inside the file.
  Future<void> _saveRideAndAttendeesToFile(File file, String extension, Ride ride, List<Member> attendees) async {
    if(extension == FileExtension.CSV.extension()){
      final buffer = StringBuffer();
      buffer.writeln(ride.toCsv());
      for(Member m in attendees){
        buffer.writeln(ExportableRideAttendee(
          firstName: m.firstname,
          lastName: m.lastname,
          alias: m.alias
        ).toCsv());
      }
      await file.writeAsString(buffer.toString());
    }else if(extension == FileExtension.JSON.extension()){
      final data = {
        "details": ride.toJson(),
        "attendees": attendees.map((a) => ExportableRideAttendee(
          firstName: a.firstname,
          lastName: a.lastname,
          alias: a.alias,
        ).toJson()).toList()
      };
      await file.writeAsString(jsonEncode(data));
    }else{
      return Future.error(InvalidFileExtensionError());
    }
  }

  @override
  void dispose() {
    _streamController.close();
    _filenameExistsController.close();
    fileNameController.dispose();
  }
}