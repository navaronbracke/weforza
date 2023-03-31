
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/ride.dart';

class ExportRideBloc extends Bloc {
  ExportRideBloc({
    @required this.ride,
    @required this.loadedAttendees,
    @required this.fileHandler,
    @required this.resolveInitialFilename,
  }): assert(ride != null && loadedAttendees != null
      && fileHandler != null
      && resolveInitialFilename != null)
  {
    final String text = resolveInitialFilename();
    _filename = text;
    fileNameController = TextEditingController(text: text);
  }

  final String Function() resolveInitialFilename;
  final IFileHandler fileHandler;
  final Ride ride;
  final Future<List<MemberItem>> loadedAttendees;
  final RegExp filenamePattern = RegExp(r"^[\w\s-]{1,80}$");
  TextEditingController fileNameController;

  final StreamController<RideExportState> _streamController = BehaviorSubject();
  Stream<RideExportState> get stream => _streamController.stream;

  final StreamController<bool> _fileExistsController = BehaviorSubject();
  Stream<bool> get fileExistsStream => _fileExistsController.stream;

  List<Member> rideAttendees;

  bool autoValidateFileName = false;

  String _filename;

  FileExtension _fileExtension = FileExtension.CSV;

  void onSelectFileExtension(FileExtension extension) => _fileExtension = extension;

  ///Form Error message
  String filenameError;

  void loadRideAttendees() async {
    _streamController.add(RideExportState.INIT);
    final attendees = await loadedAttendees;//These are already loaded!
    rideAttendees = attendees.map((a) => a.member).toList();
    _streamController.add(RideExportState.IDLE);
  }

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
    }else if(Ride.titleMaxLength < filename.length){
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

  void exportRide() async {
    await fileHandler.createFile(_filename, _fileExtension.extension()).then((file) async {
      if(await file.exists()){
        _fileExistsController.add(true);
      }else{
        _fileExistsController.add(false);
        _streamController.add(RideExportState.EXPORTING);
        await fileHandler.saveRideAndAttendeesToFile(_filename, _fileExtension.extension(), ride, rideAttendees);
        _streamController.add(RideExportState.DONE);
      }
    }).catchError((e) => _streamController.addError(e));
  }

  @override
  void dispose() {
    _streamController.close();
    _fileExistsController.close();
  }
}

enum RideExportState {
  INIT,
  IDLE,
  EXPORTING,
  DONE
}