
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/pages/rideList/rideListSelector.dart';

///This class represents a BLoC for a RideItem in RideListPage.
class RideListRideItemBloc extends Bloc implements IRideSelectable {
  RideListRideItemBloc(this._ride,this.index,this.isSelected): assert(_ride != null && isSelected != null && index != null);
  //The index of this item.
  final int index;
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

  isAttendee(Attendee attendee) => _ride.attendees.contains(attendee);

  void add(Attendee attendee) => _ride.attendees.add(attendee);

  void remove(Attendee attendee) => _ride.attendees.remove(attendee);

  Ride getRide() => _ride;

  @override
  DateTime getDateOfRide() => _ride.date;

  @override
  void unSelect() => isSelected = false;

  @override
  void select() => isSelected = true;

  @override
  int getIndex() => index;

  @override
  int getCount() => _ride.attendees.length;
}