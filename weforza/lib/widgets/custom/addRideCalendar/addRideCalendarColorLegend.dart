import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';

///This [Widget] represents a color legend for the ride calendar.
class AddRideCalendarColorLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            S.of(context).AddRideColorLegendPastDay,
            style: TextStyle(
              color: ApplicationTheme.rideCalendarPastDayWithoutRideBackgroundColor
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            S.of(context).AddRideColorLegendPastRide,
            style: TextStyle(
              color: ApplicationTheme.rideCalendarPastDayWithRideBackgroundColor
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            S.of(context).AddRideColorLegendCurrentSelection,
            style: TextStyle(
              color: ApplicationTheme.rideCalendarSelectedDayBackgroundColor
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            S.of(context).AddRideColorLegendFutureRide,
            style: TextStyle(color: ApplicationTheme.rideCalendarFutureDayWithRideBackgroundColor),
          ),
        ),
      ],
    );
  }
}