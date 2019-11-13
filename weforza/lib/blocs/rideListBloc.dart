
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
  int _selectedRideIndex = -1;

  List<RideItemModel> _rides;

  ///Load the rides from the database.
  Future<List<RideItemModel>> getRides() async {
    var data = await _rideRepository.getAllRides();
    int index = 0;
    _rides = data.map((ride){
      return RideItemModel(RideListRideItemBloc(ride,index++, false));
    }).toList();
    return _rides;
  }

  ///Get all Members without applying selection to the items.
  Future<List<RideAttendeeItemModel>> getAllMembers() async {
    List<Member> data = await _memberRepository.getAllMembers();
    List<Future<RideAttendeeItemModel>> mappedMembers = data.map((member) => _mapMemberToAttendeeItemModel(member, false)).toList();
    return await Future.wait(mappedMembers);
  }

  ///Get all Members and apply selection to the attendees of the currently selected ride.
  ///Does a fallback to [getAllMembers] if no ride is selected.
  Future<List<RideAttendeeItemModel>> getAllMembersWithAttendingSelected() async {
    if(_selectedRideIndex == -1) return getAllMembers();

    final Ride ride = _rides[_selectedRideIndex].getRide();
    List<Member> data = await _memberRepository.getAllMembers();
    List<Future<RideAttendeeItemModel>> mappedMembers = data.map((member) => _mapMemberToAttendeeItemModel(member, ride.attendees.contains(Attendee(member.firstname,member.lastname,member.phone)))).toList();
    return await Future.wait(mappedMembers);
  }

  ///Get the attendees of the currently selected ride.
  ///Does a fallback to [getAllMembers] if no ride is selected.
  Future<List<RideAttendeeItemModel>> getAttendeesOnly() async {
    if(_selectedRideIndex == -1) return getAllMembers();

    final Ride ride = _rides[_selectedRideIndex].getRide();
    List<Member> data = await _memberRepository.getAllMembers();
    List<Future<RideAttendeeItemModel>> mappedMembers = data.where((member) => ride.attendees.contains(Attendee(member.firstname,member.lastname,member.phone)))
        .map((member) => _mapMemberToAttendeeItemModel(member, true))
        .toList();
    return await Future.wait(mappedMembers);
  }

  ///Map the given params to a [RideAttendeeItemModel].
  Future<RideAttendeeItemModel> _mapMemberToAttendeeItemModel(Member member,bool isSelected) async => RideAttendeeItemModel(RideListAttendeeItemBloc(member,await FileLoader.getImage(member.profileImageFilePath),isSelected));

  ///Dispose of this object.
  @override
  void dispose() {}

  ///Select (or unselect) a given ride.
  void selectRide(IRideSelectable item) {
    //New selection
    if(_selectedRideIndex == -1){
      _selectedRideIndex = item.getIndex();
      item.select();
      filterState = AttendeeFilterState.OFF;
      attendeeCount = "${item.getCount()}";
    }
    //Same item -> unselect it
    else if(_rides[_selectedRideIndex].bloc.getDateOfRide() == item.getDateOfRide()){
      _selectedRideIndex = -1;
      item.unSelect();
      filterState = AttendeeFilterState.DISABLED;
      attendeeCount = "";
    }
    //different item -> unselect previous one and select the item
    else{
      _rides[_selectedRideIndex].bloc.unSelect();
      _selectedRideIndex = item.getIndex();
      item.select();
      attendeeCount = "${item.getCount()}";
      //if this is a new selection, enable the filter
      if(filterState == AttendeeFilterState.DISABLED){
        filterState = AttendeeFilterState.OFF;
      }
    }
  }

  ///Select an attendee.
  Future selectAttendee(IRideAttendeeSelectable item) async {
    if(_selectedRideIndex == -1) return;

    final Attendee attendee = item.getAttendee();
    if(_rides[_selectedRideIndex].isAttendeeOfRide(attendee)){
      _rides[_selectedRideIndex].remove(attendee);
      item.unSelect();
    }else{
      _rides[_selectedRideIndex].add(attendee);
      item.select();
    }
    await _rideRepository.editRide(_rides[_selectedRideIndex].getRide());
    attendeeCount = "${_rides[_selectedRideIndex].count()}";
  }
}

///This enum defines the state for the filter.
enum AttendeeFilterState {
  DISABLED,ON,OFF
}