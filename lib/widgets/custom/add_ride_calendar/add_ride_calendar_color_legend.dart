import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

/// This widget represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  const AddRideCalendarColorLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    final theme = RideCalendarTheme.fromPlatform(context);

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
                  color: theme.pastDay,
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
                    color: theme.pastRide,
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
                    color: theme.selection,
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
                  color: theme.futureRide,
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
