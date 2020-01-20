
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/model/attendeeItem.dart';
import 'package:weforza/model/attendeeScanner.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/rideAttendeeDisplayMode.dart';
import 'package:weforza/model/rideAttendeeSelector.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

class RideAttendeeAssignmentBloc extends Bloc implements AttendeeScanner, RideAttendeeSelector {
  RideAttendeeAssignmentBloc(this._rideRepository,this._memberRepository,this.ride):
        assert(_memberRepository != null && _rideRepository != null && ride != null);
  
  final Ride ride;
  final RideRepository _rideRepository;
  final MemberRepository _memberRepository;

  final StreamController<RideAttendeeDisplayMode> _displayModeController = BehaviorSubject();
  Stream<RideAttendeeDisplayMode> get displayModeStream => _displayModeController.stream;

  final StreamController<bool> _submittingController = BehaviorSubject();
  Stream<bool> get submitStream => _submittingController.stream;

  String get titleDateFormat => "d/M/yyyy";

  List<RideAttendeeAssignmentItemBloc> items;

  List<String> _rideAttendees = List();

  Future<void> get scanFuture => _scanCompleter?.future;
  Completer<void> _scanCompleter;

  Future<void> loadMembers() async {
    final members = await _memberRepository.getMembers();
    final attendees = await _memberRepository.getRideAttendeeIds(ride.date);
    items = await Future.wait(members.map((member)=> _mapMemberToItem(member,attendees.contains(member.uuid))));
    _rideAttendees.addAll(items.where((item)=> item.selected).map((item)=>item.attendee.uuid).toList());
    _displayModeController.add(RideAttendeeDisplayMode.IDLE);
  }

  Future<RideAttendeeAssignmentItemBloc> _mapMemberToItem(Member member,bool selected) async {
    return RideAttendeeAssignmentItemBloc(
        AttendeeItem(
            member.uuid,
            member.firstname,
            member.lastname,
            await _memberRepository.loadProfileImageFromDisk(member.profileImageFilePath)
        ),
        selected,
        this
    );
  }

  void onScanErrorDismissed() => _displayModeController.add(RideAttendeeDisplayMode.IDLE);

  void onSubmit() async {
    _submittingController.add(true);
    await _rideRepository.updateAttendeesForRideWithDate(ride, _rideAttendees.map(
            (uuid)=> RideAttendee(ride.date,uuid)).toList()
    ).then((_){
      _submittingController.add(false);
    },onError: (error)=> _submittingController.addError(error));
  }

  @override
  void startScan() {
    _displayModeController.add(RideAttendeeDisplayMode.SCANNING);
    //TODO if bluetooth is off -> throw error -> create dialog
    // TODO: start scan with flutter blue instance if not scanning
    _scanCompleter = Completer();
  }

  @override
  void stopScan() {
    // TODO: stop scan with flutter blue instance if scanning
    _scanCompleter.complete();
    _displayModeController.add(RideAttendeeDisplayMode.IDLE);
  }

  @override
  void select(RideAttendeeAssignmentItemBloc item) {
    if(!_rideAttendees.contains(item.attendee.uuid)){
      _rideAttendees.add(item.attendee.uuid);
      item.selected = true;
    }
  }

  @override
  void unSelect(RideAttendeeAssignmentItemBloc item) {
    if(_rideAttendees.contains(item.attendee.uuid)){
      _rideAttendees.remove(item.attendee.uuid);
      item.selected = false;
    }
  }

  @override
  void dispose() {
    _displayModeController.close();
    _submittingController.close();
  }
}