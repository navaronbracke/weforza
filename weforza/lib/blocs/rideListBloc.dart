
import 'dart:async';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/blocs/rideListAttendeeItemBloc.dart';
import 'package:weforza/blocs/rideListRideItemBloc.dart';
import 'package:weforza/file/fileLoader.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendeeItemModel.dart';
import 'package:weforza/model/rideItemModel.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/pages/rideList/rideListSelector.dart';

///This is the BLoC for RideListPage.
class RideListBloc extends Bloc {
  RideListBloc(this._memberRepository,this._rideRepository): assert(_rideRepository != null && _memberRepository != null);

  //region Repositories

  ///The [IRideRepository] that will manage the Rides section of RideListPage.
  final IRideRepository _rideRepository;
  ///The [IMemberRepository] that will manage the Members section of RideListPage.
  final IMemberRepository _memberRepository;

  //endregion

  ///The current filter state.
  AttendeeFilterState filterState = AttendeeFilterState.DISABLED;

  ///The current attendee count.
  String attendeeCount = "";

  ///The selected ride.
  IRideSelectable selectedRide;

  ///Load the rides from the database.
  Future<List<RideItemModel>> getRides() async {
    List<Ride> data = await _rideRepository.getAllRides();
    return data.map((ride) => RideItemModel(RideListRideItemBloc(ride, false))).toList();
  }

  Future<List<RideAttendeeItemModel>> getAttendees() async {
    switch(filterState){
      case AttendeeFilterState.DISABLED: return _getAllMembers();
      case AttendeeFilterState.OFF: return _getAllMembersAndAttendeesOfCurrentRide(selectedRide.getRide());
      case AttendeeFilterState.ON: return _getAttendeesOfCurrentRideOnly(selectedRide.getRide());
    }
    return Future.value(List());
  }



  ///Get all members from the database.
  ///There will be no selection in the returned values.
  ///This function is used when the filter is DISABLED.
  Future<List<RideAttendeeItemModel>> _getAllMembers() async {
    List<Member> data = await _memberRepository.getAllMembers();
    List<Future<RideAttendeeItemModel>> mappedMembers = data.map((member) => _mapMemberToAttendeeItemModel(member, false)).toList();
    return await Future.wait(mappedMembers);
  }

  ///Get the members from the database.
  ///The members, that are attending the given ride, will be marked.
  ///This function is used when a ride is selected and the filter is OFF.
  Future<List<RideAttendeeItemModel>> _getAllMembersAndAttendeesOfCurrentRide(Ride ride) async {
    List<Member> data = await _memberRepository.getAllMembers();
    List<Future<RideAttendeeItemModel>> mappedMembers = data.map((member) => _mapMemberToAttendeeItemModel(member, ride.attendees.contains(Attendee(member.firstname,member.lastname,member.phone)))).toList();
    return await Future.wait(mappedMembers);
  }

  ///Get the members that are attending the given ride.
  ///This function is used when a ride is selected and the filter is ON.
  Future<List<RideAttendeeItemModel>> _getAttendeesOfCurrentRideOnly(Ride ride) async {
    List<Member> data = await _memberRepository.getAllMembers();
    List<Future<RideAttendeeItemModel>> mappedMembers = data.where((member) => ride.attendees.contains(Attendee(member.firstname,member.lastname,member.phone)))
        .map((member) => _mapMemberToAttendeeItemModel(member, true))
        .toList();
    return await Future.wait(mappedMembers);
  }


  ///Map the given params to a [RideAttendeeItemModel].
  Future<RideAttendeeItemModel> _mapMemberToAttendeeItemModel(Member member,bool isSelected) async => RideAttendeeItemModel(RideListAttendeeItemBloc(member,isSelected), await FileLoader.getImage(member.profileImageFilePath));

  ///Dispose of this object.
  @override
  void dispose() {}

  void selectRide(IRideSelectable item) {
    if(selectedRide != null){
      selectedRide.select();
    }
    selectedRide = item;
    selectedRide.select();
    attendeeCount = "${selectedRide.getRide().attendees.length}";
    if(filterState == AttendeeFilterState.DISABLED){
      filterState = AttendeeFilterState.OFF;
    }
  }

  void selectAttendee(IRideAttendeeSelectable item) async {
    if(selectedRide == null) return;

    Attendee attendee = item.getAttendee();
    if(selectedRide.isAttendeeOf(attendee)){
      selectedRide.remove(attendee);
    }else{
      selectedRide.add(attendee);
    }
    item.select();
    await _rideRepository.editRide(selectedRide.getRide());
    attendeeCount = "${selectedRide.getRide().attendees.length}";
  }
}

///This enum defines the state for the filter.
enum AttendeeFilterState {
  DISABLED,ON,OFF
}