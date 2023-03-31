import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

/// This widget represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  const AddRideCalendarColorLegend({super.key});

  final double dotSize = 12;

  /// Build a row in the color legend.
  Widget _buildLegendRow({
    required Color color,
    required String label,
    bool useBottomPadding = true,
  }) {
    final child = Row(
      children: [
        Container(
          height: dotSize,
          width: dotSize,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: color,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            label,
            softWrap: true,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );

    if (useBottomPadding) {
      return Padding(padding: const EdgeInsets.only(bottom: 4), child: child);
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
          ),
          _buildLegendRow(
            color: theme.futureRide,
            label: translator.FutureRide,
          ),
          _buildLegendRow(
            color: theme.pastRide,
            label: translator.PastDayWithRide,
          ),
          _buildLegendRow(
            color: theme.pastDay,
            label: translator.PastDayNoRide,
            useBottomPadding: false,
          ),
        ],
      ),
    );
  }
}
