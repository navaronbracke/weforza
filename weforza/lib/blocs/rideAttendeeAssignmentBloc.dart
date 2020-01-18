
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/attendeeItem.dart';
import 'package:weforza/model/attendeeScanner.dart';
import 'package:weforza/model/rideAttendeeAssignmentPageDisplayMode.dart';

class RideAttendeeAssignmentBloc extends Bloc implements AttendeeScanner {

  String get titleDateFormat => "d/M/yyyy";

  List<AttendeeItem> members;

  StreamController<RideAttendeeAssignmentPageDisplayMode> _displayModeController = BehaviorSubject();
  Stream<RideAttendeeAssignmentPageDisplayMode> get displayMode => _displayModeController.stream;

  ///The current display mode for the stream.
  RideAttendeeAssignmentPageDisplayMode _attendeeAssignmentPageDisplayMode = RideAttendeeAssignmentPageDisplayMode.LOADING;


  @override
  void dispose() {
    _displayModeController.close();
  }

  @override
  void startScan() {
    if(_attendeeAssignmentPageDisplayMode == RideAttendeeAssignmentPageDisplayMode.IDLE){
      _attendeeAssignmentPageDisplayMode = RideAttendeeAssignmentPageDisplayMode.SCANNING;
      _displayModeController.add(_attendeeAssignmentPageDisplayMode);
      // TODO: implement startScan -> trigger bluetooth scan with flutter blue instance
    }
  }

  @override
  void stopScan() {
    if(_attendeeAssignmentPageDisplayMode == RideAttendeeAssignmentPageDisplayMode.SCANNING || _attendeeAssignmentPageDisplayMode == RideAttendeeAssignmentPageDisplayMode.SCANNING_ERROR){
      _attendeeAssignmentPageDisplayMode = RideAttendeeAssignmentPageDisplayMode.IDLE;
      _displayModeController.add(_attendeeAssignmentPageDisplayMode);
      // TODO: implement stopScan -> stop scan with flutter blue instance

    }
  }
}