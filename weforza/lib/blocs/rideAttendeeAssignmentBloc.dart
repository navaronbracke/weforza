
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

  @override
  void dispose() {
    _displayModeController.close();
  }

  @override
  void startScan() {
    // TODO: implement startScan
  }

  @override
  void stopScan() {
    // TODO: implement stopScan
  }
}