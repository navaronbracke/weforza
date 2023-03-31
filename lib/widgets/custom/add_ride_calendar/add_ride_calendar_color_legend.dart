import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';

/// This widget represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  const AddRideCalendarColorLegend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

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
                child: Text(translator.PastDayNoRide, softWrap: true),
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
                  child: Text(translator.PastDayWithRide, softWrap: true),
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
                  child: Text(translator.CurrentSelection, softWrap: true),
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
                child: Text(translator.FutureRide, softWrap: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
