
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:weforza/model/rideCalendarEvent.dart';

///This interface defines a contract for picking rides in a calendar.
abstract class IRidePicker {
  ///Get the selected date.
  DateTime get selectedDate;

  ///The collection of marked dates.
  EventList<RideCalendarEvent> get markedDates;

  ///The on day pressed callback.
  Function(DateTime date,List<RideCalendarEvent> events) get onDayPressed;

  ///Load the existing rides into the calendar.
  Future loadRides();
}