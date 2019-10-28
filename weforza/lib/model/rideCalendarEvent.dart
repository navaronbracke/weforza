
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:weforza/model/ride.dart';

///This class represents a model object for a Calendar.
class RideCalendarEvent extends Event {
  RideCalendarEvent(this._ride): assert(_ride != null),
        super(date: _ride.date);

  ///The Ride of the event.
  final Ride _ride;

}