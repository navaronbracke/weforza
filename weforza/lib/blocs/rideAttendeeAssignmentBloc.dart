
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
import 'package:weforza/model/rideAttendeeSelector.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

class RideAttendeeAssignmentBloc extends Bloc implements RideAttendeeSelector {
  RideAttendeeAssignmentBloc(this.ride,this._rideRepository,this._memberRepository):
        assert(ride != null && _memberRepository != null && _rideRepository != null);

  ///The [Ride] for which to change the attendees.
  final Ride ride;
  final RideRepository _rideRepository;
  final MemberRepository _memberRepository;

  ///The items contain the fully loaded [MemberItem]s and their selection state.
  ///They are stored here so the scanning widget won't have to reload the members during its init step.
  ///This way it only needs to load the devices and put both the members and devices into their respective Map.
  List<RideAttendeeAssignmentItemBloc> items;

  ///This [BehaviorSubject] controls whether the page actions should be shown.
  final StreamController<bool> _actionsDisplayModeController = BehaviorSubject();
  Stream<bool> get actionsDisplayModeStream => _actionsDisplayModeController.stream;

  ///This [BehaviorSubject] controls what content page is shown.
  final StreamController<RideAttendeeAssignmentContentDisplayMode> _contentDisplayModeController = BehaviorSubject();
  Stream<RideAttendeeAssignmentContentDisplayMode> get contentDisplayModeStream => _contentDisplayModeController.stream;

  //TODO scanning stream + scan state
  //(init: load data + organize into Map)
  //(scan: find devices)
  //(process: do lookup for each result)


  ///The UUID's of the [Member]s that should be saved as Attendees of [ride] on submit.
  List<String> _rideAttendees = List();

  Future<List<RideAttendeeAssignmentItemBloc>> loadMembers() async {
    _actionsDisplayModeController.add(false);
    final members = await _memberRepository.getMembers();
    if(members.isNotEmpty){
      final attendees = await _memberRepository.getRideAttendeeIds(ride.date);
      items = await Future.wait(members.map((member)=> _mapMemberToItem(member,attendees.contains(member.uuid))));
      _rideAttendees.addAll(items.where((item)=> item.selected).map((item)=>item.member.uuid).toList());
      _actionsDisplayModeController.add(true);
      _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.LIST);
    }
    return items;
  }

  Future<RideAttendeeAssignmentItemBloc> _mapMemberToItem(Member member,bool selected) async {
    return RideAttendeeAssignmentItemBloc(
        MemberItem(member,await _memberRepository.loadProfileImageFromDisk(member.profileImageFilePath)),
        selected,
        this
    );
  }

  Future<void> onSubmit() async {
    _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.SAVE);
    _actionsDisplayModeController.add(false);
    await _rideRepository.updateAttendeesForRideWithDate(ride, _rideAttendees.map(
            (uuid)=> RideAttendee(ride.date,uuid)).toList()
    ).then((_){
      RideProvider.reloadRides = true;
      RideProvider.selectedRide = ride;
    });
  }

  String getTitle(BuildContext context){
    return S.of(context).RideAttendeeAssignmentTitle(
        DateFormat("d/M/yyyy", Localizations.localeOf(context).languageCode)
            .format(ride.date));
  }

  void startScan() {
    _actionsDisplayModeController.add(false);
    _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.SCAN);
    //TODO if bluetooth is off -> throw error -> create dialog
    // TODO: start scan with flutter blue instance if not scanning
    //TODO when scan failed -> show widget which has a return button( onPressed = stopScan() )
  }

  void stopScan() {
    // TODO: stop scan with flutter blue instance if scanning
    _actionsDisplayModeController.add(true);
    _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.LIST);
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
    _contentDisplayModeController.close();
    _actionsDisplayModeController.close();
  }
}

///[RideAttendeeAssignmentContentDisplayMode.LIST] The page is in List mode.
///Here the attendees will be loaded. This can finish with an error or with data.
///The list will use a [FutureBuilder] to show itself.
///[RideAttendeeAssignmentContentDisplayMode.SCAN] The page is in Scan mode.
///[RideAttendeeAssignmentContentDisplayMode.SAVE] The page is saving the selection.
enum RideAttendeeAssignmentContentDisplayMode {
  LIST,
  SCAN,
  SAVE,
}