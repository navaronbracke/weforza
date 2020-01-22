
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/model/attendeeScanner.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/rideAttendeeDisplayMode.dart';
import 'package:weforza/model/rideAttendeeSelector.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

class RideAttendeeAssignmentBloc extends Bloc implements AttendeeScanner, RideAttendeeSelector {
  RideAttendeeAssignmentBloc(this._rideRepository,this._memberRepository):
        assert(_memberRepository != null && _rideRepository != null);

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

  Future<void> loadMembers(Ride ride) async {
    final members = await _memberRepository.getMembers();
    final attendees = await _memberRepository.getRideAttendeeIds(ride.date);
    items = await Future.wait(members.map((member)=> _mapMemberToItem(member,attendees.contains(member.uuid))));
    _rideAttendees.addAll(items.where((item)=> item.selected).map((item)=>item.member.uuid).toList());
    _displayModeController.add(RideAttendeeDisplayMode.IDLE);
  }

  Future<RideAttendeeAssignmentItemBloc> _mapMemberToItem(Member member,bool selected) async {
    return RideAttendeeAssignmentItemBloc(
        MemberItem(member,await _memberRepository.loadProfileImageFromDisk(member.profileImageFilePath)),
        selected,
        this
    );
  }

  void onScanErrorDismissed() => _displayModeController.add(RideAttendeeDisplayMode.IDLE);

  Future<bool> onSubmit(Ride ride) async {
    bool result = false;
    _submittingController.add(true);
    await _rideRepository.updateAttendeesForRideWithDate(ride, _rideAttendees.map(
            (uuid)=> RideAttendee(ride.date,uuid)).toList()
    ).then((_){
      RideProvider.reloadRides = true;
      _submittingController.add(false);
      result = true;
    },onError: (error)=> _submittingController.addError(error));
    return result;
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
    if(!_rideAttendees.contains(item.member.uuid)){
      _rideAttendees.add(item.member.uuid);
      item.selected = true;
    }
  }

  @override
  void unSelect(RideAttendeeAssignmentItemBloc item) {
    if(_rideAttendees.contains(item.member.uuid)){
      _rideAttendees.remove(item.member.uuid);
      item.selected = false;
    }
  }

  @override
  void dispose() {
    _displayModeController.close();
    _submittingController.close();
  }
}