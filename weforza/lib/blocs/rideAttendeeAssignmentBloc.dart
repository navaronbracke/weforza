
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

  final StreamController<String> _messageController = BehaviorSubject();
  Stream<String> get messageStream => _messageController.stream;

  final StreamController<RideAttendeeDisplayMode> _displayModeController = BehaviorSubject();
  Stream<RideAttendeeDisplayMode> get displayModeStream => _displayModeController.stream;

  String get titleDateFormat => "d/M/yyyy";

  List<RideAttendeeAssignmentItemBloc> items;

  Future<void> get scanFuture => _scanCompleter?.future;
  Completer<void> _scanCompleter;

  Future<void> loadMembers() async {
    final members = await _memberRepository.getMembers();
    final attendees = await _memberRepository.getRideAttendeeIds(ride.date);
    items = await Future.wait(members.map((member)=> _mapMemberToItem(member,attendees.contains(member.uuid))));
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
  void select(RideAttendeeAssignmentItemBloc item) async {
    await _rideRepository.addAttendeeToRide(ride, RideAttendee(ride.date,item.attendee.uuid)).then((value){
      item.selected = true;
    },onError: (error)=> _messageController.addError(error));
  }

  @override
  void unSelect(RideAttendeeAssignmentItemBloc item) async {
    await _rideRepository.removeAttendee(ride, item.attendee.uuid).then((value){
      item.selected = false;
    },onError: (error) => _messageController.addError(error));
  }

  @override
  void dispose() {
    _messageController.close();
    _displayModeController.close();
  }
}