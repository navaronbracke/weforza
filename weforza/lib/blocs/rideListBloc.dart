
import 'dart:async';

import 'package:rxdart/rxdart.dart';
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

  ///The list of rides that are selected for deletion.
  List<DateTime> _ridesToBeDeleted = List();

  ///The current ride selection mode.
  RideSelectionMode selectionMode = RideSelectionMode.NORMAL;

  StreamController<String> _attendeeCountController = BehaviorSubject();
  Stream<String> get attendeeCount => _attendeeCountController.stream;

  ///The selected ride.
  int _selectedRideIndex = -1;

  List<RideItemModel> _rides;

  ///The controller for the display mode.
  StreamController<PanelDisplayMode> _displayModeController = BehaviorSubject();
  Stream<PanelDisplayMode> get displayStream => _displayModeController.stream;

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
  void dispose() {
    _displayModeController.close();
    _attendeeCountController.close();
  }

  void enableDeletionMode(){
    if(selectionMode == RideSelectionMode.NORMAL){
      selectionMode = RideSelectionMode.DELETION;
      _displayModeController.add(PanelDisplayMode.RIDE_DELETION);
    }
  }

  ///Select (or unselect) a given ride.
  void selectRide(IRideSelectable item) {
    //Delete selection mode
    if(selectionMode == RideSelectionMode.DELETION){
      _selectedRideIndex = -1;//unselect selected ride
      _attendeeCountController.add("");
      filterState = AttendeeFilterState.DISABLED;
      DateTime date = item.getDateOfRide();
      if(_ridesToBeDeleted.contains(date)){
        _ridesToBeDeleted.remove(date);
        item.unSelect();
      }else{
        _ridesToBeDeleted.add(date);
        item.select();
      }
      selectionMode = _ridesToBeDeleted.isEmpty ? RideSelectionMode.NORMAL : RideSelectionMode.DELETION;
      _displayModeController.add(selectionMode == RideSelectionMode.NORMAL ? PanelDisplayMode.ATTENDEES : PanelDisplayMode.RIDE_DELETION);
    }else{
      //Normal selection mode

      //New selection
      if(_selectedRideIndex == -1){
        _selectedRideIndex = item.getIndex();
        item.select();
        filterState = AttendeeFilterState.OFF;
        _attendeeCountController.add("${item.getCount()}");
      }
      //Same item -> unselect it
      else if(_rides[_selectedRideIndex].bloc.getDateOfRide() == item.getDateOfRide()){
        _selectedRideIndex = -1;
        item.unSelect();
        filterState = AttendeeFilterState.DISABLED;
        _attendeeCountController.add("");
      }
      //different item -> unselect previous one and select the item
      else{
        _rides[_selectedRideIndex].bloc.unSelect();
        _selectedRideIndex = item.getIndex();
        item.select();
        _attendeeCountController.add("${item.getCount()}");
        //if this is a new selection, enable the filter
        if(filterState == AttendeeFilterState.DISABLED){
          filterState = AttendeeFilterState.OFF;
        }
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
    _attendeeCountController.add("${_rides[_selectedRideIndex].count()}");
  }
}

///This enum defines the state for the filter.
enum AttendeeFilterState {
  DISABLED,ON,OFF
}

///This enum defines the state for the selection mode.
///[RideSelectionMode.NORMAL] is the standard selection mode, where rides can be selected for showing attendees.
enum RideSelectionMode {
  NORMAL,DELETION
}

///This enum defines the panel display mode for this bloc's Widget.
///It defines which panel is displayed on the right side.
enum PanelDisplayMode {
  ATTENDEES, BLUETOOTH, RIDE_DELETION
}