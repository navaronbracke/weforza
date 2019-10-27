import 'package:flutter/widgets.dart';
import 'package:weforza/model/rideCalendarEvent.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

///This [Widget] represents a Calendar for picking Ride dates.
class AddRideCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CalendarCarousel<RideCalendarEvent>(
      onDayPressed: (date,events){
        //TODO
      },
    );
  }
}
