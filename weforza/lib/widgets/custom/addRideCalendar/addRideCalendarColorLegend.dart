import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';

///This [Widget] represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ApplicationTheme.rideCalendarPastDayWithoutRideBackgroundColor,
                ),
              ),
              SizedBox(width: 10),
              Text(S.of(context).AddRideColorLegendPastDay,softWrap: true),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ApplicationTheme.rideCalendarPastDayWithRideBackgroundColor,
                ),
              ),
              SizedBox(width: 10),
              Text(S.of(context).AddRideColorLegendPastRide,softWrap: true),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ApplicationTheme.rideCalendarSelectedDayBackgroundColor,
                ),
              ),
              SizedBox(width: 10),
              Text(S.of(context).AddRideColorLegendCurrentSelection,softWrap: true),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ApplicationTheme.rideCalendarFutureDayWithRideBackgroundColor,
                ),
              ),
              SizedBox(width: 10),
              Text(S.of(context).AddRideColorLegendFutureRide,softWrap: true),
            ],
          ),
        ],
      ),
    );
  }
}