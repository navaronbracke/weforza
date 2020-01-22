
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/rideAttendeeSelector.dart';

class RideAttendeeAssignmentItemBloc extends Bloc {
  RideAttendeeAssignmentItemBloc(this.member,this.selected,this.selector):
        assert(member != null && selected != null && selector != null);

  final RideAttendeeSelector selector;
  final MemberItem member;
  bool selected;

  File get image => member.profileImage;
  String get firstName => member.firstName;
  String get lastName => member.lastName;

  @override
  void dispose() {}

  void onSelected() {
    if(selected){
      selector.unSelect(this);
    }else{
      selector.select(this);
    }
  }
}