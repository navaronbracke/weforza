
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/rideAttendeeDisplayMode.dart';
import 'package:weforza/model/rideAttendeeSelector.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

class RideAttendeeAssignmentBloc extends Bloc implements RideAttendeeSelector {
  RideAttendeeAssignmentBloc(this.ride,this._rideRepository,this._memberRepository):
        assert(ride != null && _memberRepository != null && _rideRepository != null);

  final Ride ride;
  final RideRepository _rideRepository;
  final MemberRepository _memberRepository;

  final StreamController<RideAttendeeDisplayMode> _displayModeController = BehaviorSubject();
  Stream<RideAttendeeDisplayMode> get displayModeStream => _displayModeController.stream;

  List<RideAttendeeAssignmentItemBloc> items;

  List<String> _rideAttendees = List();

  Future<void> get scanFuture => _scanCompleter?.future;
  Completer<void> _scanCompleter;

  Future<void> loadMembers() async {
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

  Future<bool> onSubmit() async {
    bool result = false;
    await _rideRepository.updateAttendeesForRideWithDate(ride, _rideAttendees.map(
            (uuid)=> RideAttendee(ride.date,uuid)).toList()
    ).then((_){
      RideProvider.reloadRides = true;
      RideProvider.selectedRide = ride;
      result = true;
    },onError: (error) => //errors are handled in the StreamBuilder that consumes this stream
        _displayModeController.addError(error));
    return result;
  }

  String getTitle(BuildContext context){
    return S.of(context).RideAttendeeAssignmentTitle(
        DateFormat("d/M/yyyy", Localizations.localeOf(context).languageCode)
            .format(ride.date));
  }
  
  void startScan() {
    //errors are handled by the FutureBuilder that consumes the scan future
    _displayModeController.add(RideAttendeeDisplayMode.SCANNING);
    //TODO if bluetooth is off -> throw error -> create dialog
    // TODO: start scan with flutter blue instance if not scanning
    _scanCompleter = Completer();
  }

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
  }
}