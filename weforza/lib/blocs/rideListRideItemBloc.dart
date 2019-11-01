
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';

///This class represents a BLoC for a RideItem in RideListPage.
class RideListRideItemBloc extends Bloc {
  RideListRideItemBloc(this.ride,this.isSelected): assert(ride != null && isSelected != null);

  ///The internal ride object.
  final Ride ride;

  bool isSelected;


  String getFormattedDate(BuildContext context){
    assert(context != null);
    return ride.getFormattedDate(context);
  }

  DateTime getDate() => ride.date;

  @override
  void dispose() {}

  isAttendee(Attendee attendee) => ride.attendees.contains(attendee);

  void add(Attendee attendee) => ride.attendees.add(attendee);

  void remove(Attendee attendee) => ride.attendees.remove(attendee);
}