import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

/// This widget represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  const AddRideCalendarColorLegend({super.key});

  /// Build a row in the color legend.
  Widget _buildLegendRow({
    required Color color,
    required String label,
    EdgeInsets? padding,
  }) {
    final child = Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: color,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(label, softWrap: true),
        ),
      ],
    );

    if (padding != null) {
      return Padding(padding: padding, child: child);
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);
    final theme = RideCalendarTheme.fromPlatform(context);

    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildLegendRow(
            color: theme.selection,
            label: translator.CurrentSelection,
            padding: const EdgeInsets.only(bottom: 4),
          ),
          _buildLegendRow(
            color: theme.futureRide,
            label: translator.FutureRide,
            padding: const EdgeInsets.only(bottom: 4),
          ),
          _buildLegendRow(
            color: theme.pastRide,
            label: translator.PastDayWithRide,
            padding: const EdgeInsets.only(bottom: 4),
          ),
          _buildLegendRow(
            color: theme.pastDay,
            label: translator.PastDayNoRide,
          ),
        ],
      ),
    );
  }
}
