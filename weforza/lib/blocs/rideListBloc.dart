
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

///This is the BLoC for RideListPage.
class RideListBloc extends Bloc {
  RideListBloc(this._memberRepository,this._rideRepository): assert(_rideRepository != null && _memberRepository != null);

  ///The [IRideRepository] that will manage the Rides section of RideListPage.
  final IRideRepository _rideRepository;
  ///The [IMemberRepository] that will manage the Members section of RideListPage.
  final IMemberRepository _memberRepository;

  ///Show only the attending people.
  bool showAttendingOnly = false;

  ///The [StreamController] for the attending count.
  StreamController<String> _attendingCountController = StreamController.broadcast();

  ///Get the stream of [_attendingCountController].
  Stream<String> get attendingCount => _attendingCountController.stream.asBroadcastStream();

  ///The current [RideSelectionState].
  RideSelectionState rideSelectionState = RideSelectionState.UNSELECTED;

  ///The index of the selected ride.
  int _selectedRideIndex = -1;

  ///The selected members.
  List<int> _selectedMemberIndexes = List();

  ///Get the rides, with the selected item marked.
  Future<List<RideItemModel>> getRides() async {
    List<Ride> rides = await _rideRepository.getAllRides();
    if(rideSelectionState == RideSelectionState.UNSELECTED){
      //return all the rides, with no selected item
      return rides.map((ride)=> RideItemModel(RideListRideItemBloc(ride,false))).toList();
    }else {
      ///return all the rides BUT the selected ride gets marked
      int index = 0;
      return rides.map((ride){
        RideItemModel model = RideItemModel(RideListRideItemBloc(ride,index == _selectedRideIndex));
        index++;
        return model;
      }).toList();
    }
  }

  Future<List<RideAttendeeItemModel>> getAttendees() async {
    List<Member> members = await _memberRepository.getAllMembers();
    List<RideAttendeeItemModel> items;
    if(rideSelectionState == RideSelectionState.UNSELECTED){
      //return all members, with no selected items.
      //First map all the items, async since we load images.
      List<Future<RideAttendeeItemModel>> futures = members.map((member) async  => await _mapMemberToAttendeeItemModel(member, false)).toList();
      items = await Future.wait(futures);
      _attendingCountController.add("");
      return items;
    }else{
      if(showAttendingOnly){
        //show only the selected
        items = List();
        for (int i = 0; i < members.length; i++){
          //Add the item if its index equals a selected member.
          if(_selectedMemberIndexes.contains(i)){
            items.add(await _mapMemberToAttendeeItemModel(members[i],true));
          }
        }
        _attendingCountController.add("${items.length}");
        return items;
      }else{
        //show all members with the selected marked
        int index = 0;
        List<Future<RideAttendeeItemModel>> futures = members.map((member) async => await _mapMemberToAttendeeItemModel(member, _selectedMemberIndexes.contains(index))).toList();
        items = await Future.wait(futures);
        _attendingCountController.add("${items.length}");
        return items;
      }
    }
  }

  ///Map the given params to a [RideAttendeeItemModel].
  Future<RideAttendeeItemModel> _mapMemberToAttendeeItemModel(Member member,bool isSelected) async => RideAttendeeItemModel(RideListAttendeeItemBloc(member,isSelected), await FileLoader.getImage(member.profileImageFilePath));

  ///Dispose of this object.
  @override
  void dispose() {
    _attendingCountController.close();
  }
}

///This enum defines the selection state for the Ride portion of the list.
enum RideSelectionState {
  UNSELECTED,SELECTED
}