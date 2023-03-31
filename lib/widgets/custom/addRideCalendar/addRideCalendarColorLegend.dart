import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';

///This [Widget] represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  const AddRideCalendarColorLegend({Key? key}) : super(key: key);

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
                  color: ApplicationTheme
                      .rideCalendarPastDayWithoutRideBackgroundColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(S.of(context).AddRideColorLegendPastDay,
                    softWrap: true),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ApplicationTheme
                        .rideCalendarPastDayWithRideBackgroundColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(S.of(context).AddRideColorLegendPastRide,
                      softWrap: true),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        ApplicationTheme.rideCalendarSelectedDayBackgroundColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(S.of(context).AddRideColorLegendCurrentSelection,
                      softWrap: true),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ApplicationTheme
                      .rideCalendarFutureDayWithRideBackgroundColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(S.of(context).AddRideColorLegendFutureRide,
                    softWrap: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
