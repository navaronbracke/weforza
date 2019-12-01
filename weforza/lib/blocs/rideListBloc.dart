
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
  List<IRideSelectable> _ridesToBeDeleted = List();

  ///The current display mode.
  PanelDisplayMode displayMode = PanelDisplayMode.ATTENDEES;

  StreamController<String> _attendeeCountController = BehaviorSubject();
  Stream<String> get attendeeCount => _attendeeCountController.stream;

  IRideSelectable _selectedRide;

  List<RideItemModel> _rides;

  ///The controller for the display mode.
  StreamController<PanelDisplayMode> _displayModeController = BehaviorSubject();
  Stream<PanelDisplayMode> get displayStream => _displayModeController.stream;

  ///Load the rides from the database.
  Future<List<RideItemModel>> getRides() async {
    var data = await _rideRepository.getAllRides();
    _rides = data.map((ride){
      return RideItemModel(RideListRideItemBloc(ride, false));
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
    if(_selectedRide == null) return getAllMembers();

    final Ride ride = _selectedRide.getRide();
    List<Member> data = await _memberRepository.getAllMembers();
    List<Future<RideAttendeeItemModel>> mappedMembers = data.map((member) => _mapMemberToAttendeeItemModel(member, ride.attendees.contains(Attendee(member.firstname,member.lastname,member.phone)))).toList();
    return await Future.wait(mappedMembers);
  }

  ///Get the attendees of the currently selected ride.
  ///Does a fallback to [getAllMembers] if no ride is selected.
  Future<List<RideAttendeeItemModel>> getAttendeesOnly() async {
    if(_selectedRide == null) return getAllMembers();

    final Ride ride = _selectedRide.getRide();
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
    if(displayMode == PanelDisplayMode.ATTENDEES){
      //unselect any selected ride from normal selection mode
      //and reset counter / filter
      if(_selectedRide != null){
        _selectedRide.unSelect();
        _selectedRide = null;
        _attendeeCountController.add("");
        filterState = AttendeeFilterState.DISABLED;
      }
      displayMode = PanelDisplayMode.RIDE_DELETION;
      _displayModeController.add(displayMode);
    }
  }

  void resetSelectionMode(){
    displayMode = PanelDisplayMode.ATTENDEES;
    _ridesToBeDeleted.forEach((item)=> item.unSelect());
    _ridesToBeDeleted = List();
    _displayModeController.add(displayMode);
  }

  ///Select (or unselect) a given ride.
  void selectRide(IRideSelectable item) {
    //Delete selection mode
    if(displayMode == PanelDisplayMode.RIDE_DELETION){
      if(_ridesToBeDeleted.contains(item)){
        _ridesToBeDeleted.remove(item);
        item.unSelect();
        if(_ridesToBeDeleted.isEmpty){
          displayMode = PanelDisplayMode.ATTENDEES;
          _displayModeController.add(displayMode);
        }
      }else{
        _ridesToBeDeleted.add(item);
        item.select();
        displayMode = PanelDisplayMode.RIDE_DELETION;
        _displayModeController.add(displayMode);
      }
    }else{
      //Normal selection mode

      //New selection
      if(_selectedRide == null){
        _selectedRide = item;
        item.select();
        filterState = AttendeeFilterState.OFF;
        _attendeeCountController.add("${item.getCount()}");
      }
      //Same item -> unselect it
      else if(_selectedRide == item){
        _selectedRide = null;
        item.unSelect();
        filterState = AttendeeFilterState.DISABLED;
        _attendeeCountController.add("");
      }
      //different item -> unselect previous one and select the item
      else{
        _selectedRide.unSelect();
        _selectedRide = item;
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
    if(_selectedRide == null) return;

    final Attendee attendee = item.getAttendee();
    if(_selectedRide.isAttendeeOfRide(attendee)){
      _selectedRide.removeAttendee(attendee);
      item.unSelect();
    }else{
      _selectedRide.addAttendee(attendee);
      item.select();
    }
    await _rideRepository.editRide(_selectedRide.getRide());
    _attendeeCountController.add("${_selectedRide.getCount()}");
  }

  Future<bool> hasMembers() => _memberRepository.hasMembers();

  void catchHasMembersError(){
    _displayModeController.addError(Exception("Could not check if there are members"));
  }
}

///This enum defines the state for the filter.
enum AttendeeFilterState {
  DISABLED,ON,OFF
}

///This enum defines the panel display mode for this bloc's Widget.
///It defines which panel is displayed on the right side.
enum PanelDisplayMode {
  ATTENDEES, BLUETOOTH, RIDE_DELETION
}