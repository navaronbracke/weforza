
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/attendee.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/pages/rideList/rideListSelector.dart';

///This class represents a BLoC for a RideItem in RideListPage.
class RideListRideItemBloc extends Bloc implements IRideSelectable {
  RideListRideItemBloc(this._ride,this.isSelected): assert(_ride != null && isSelected != null);
  ///The internal ride object.
  final Ride _ride;
  //Whether this item is selected.
  bool isSelected;

  String getFormattedDate(BuildContext context){
    assert(context != null);
    return _ride.getFormattedDate(context);
  }

  @override
  void dispose() {}

  @override
  isAttendeeOfRide(Attendee attendee) => _ride.attendees.contains(attendee);

  @override
  void addAttendee(Attendee attendee) => _ride.attendees.add(attendee);

  @override
  void removeAttendee(Attendee attendee) => _ride.attendees.remove(attendee);

  @override
  Ride getRide() => _ride;

  @override
  void unSelect() => isSelected = false;

  @override
  void select() => isSelected = true;

  @override
  int getCount() => _ride.attendees.length;
}