
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/attendeeItem.dart';
import 'package:weforza/model/rideAttendeeSelector.dart';

class RideAttendeeAssignmentItemBloc extends Bloc {
  RideAttendeeAssignmentItemBloc(this.attendee,this.selected,this.selector):
        assert(attendee != null && selected != null && selector != null);

  final RideAttendeeSelector selector;
  final AttendeeItem attendee;
  bool selected;

  File get image => attendee.picture;
  String get firstName => attendee.firstName;
  String get lastName => attendee.lastName;

  bool _busy = false;

  @override
  void dispose() {}

  void onSelected() {
    if(!_busy){
      _busy = true;
      if(selected){
        selector.unSelect(this);
      }else{
        selector.select(this);
      }
      _busy = false;
    }
  }
}