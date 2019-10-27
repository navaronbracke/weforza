import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:weforza/model/rideCalendarEvent.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/custom/addRideCalendar/iRidePicker.dart';

///This [Widget] represents a Calendar for picking Ride dates.
class AddRideCalendar extends StatelessWidget {
  AddRideCalendar(this._picker): assert(_picker != null);

  ///The handler for this [Widget].
  final IRidePicker _picker;

  @override
  Widget build(BuildContext context) {
    return CalendarCarousel<RideCalendarEvent>(
      onDayPressed: _picker.onDayPressed,
      selectedDateTime: _picker.selectedDate,
      daysHaveCircularBorder: null,
      markedDatesMap: _picker.markedDates,
    );
  }
}
