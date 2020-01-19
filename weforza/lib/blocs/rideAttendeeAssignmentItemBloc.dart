
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/attendeeItem.dart';
import 'package:weforza/model/rideAttendeeSelector.dart';

class RideAttendeeAssignmentItemBloc extends Bloc {
  RideAttendeeAssignmentItemBloc(this.attendee,this.selected,this.selector): assert(attendee != null && selected != null && selector != null);

  final RideAttendeeSelector selector;
  final AttendeeItem attendee;
  bool selected;

  File get image => attendee.picture;
  String get firstName => attendee.firstName;
  String get lastName => attendee.lastName;

  @override
  void dispose() {}

  void onSelected() {
    if(selected){
      selector.select(this);
    }else{
      selector.unSelect(this);
    }
  }
}