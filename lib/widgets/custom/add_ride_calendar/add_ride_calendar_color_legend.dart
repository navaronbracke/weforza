import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';

/// This widget represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  const AddRideCalendarColorLegend({super.key});

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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ApplicationTheme
                      .rideCalendarPastDayWithoutRideBackgroundColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(translator.PastDayNoRide, softWrap: true),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: ApplicationTheme
                        .rideCalendarPastDayWithRideBackgroundColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(translator.PastDayWithRide, softWrap: true),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color:
                        ApplicationTheme.rideCalendarSelectedDayBackgroundColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ApplicationTheme
                      .rideCalendarFutureDayWithRideBackgroundColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(translator.FutureRide, softWrap: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
