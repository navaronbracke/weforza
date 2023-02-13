import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

/// This widget represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  const AddRideCalendarColorLegend({super.key});

  /// The size of the dot next to a label.
  final double dotSize = 12;

  /// The max lines for a label of a legend item.
  final int labelMaxLines = 2;

  /// The text style for a label of a legend item.
  ///
  /// This style has a fixed [TextStyle.height], so that the total height of
  /// a label item can be computed by the [labelMaxHeight] getter.
  final TextStyle labelStyle = const TextStyle(fontSize: 14, height: 1);

  /// Get the max height of the label of a legend item.
  double get labelMaxHeight => labelStyle.fontSize! * labelMaxLines;

  /// Build an item in the color legend.
  Widget _buildLegendItem({
    required Color color,
    required AxisDirection dotDirection,
    required String label,
  }) {
    final dot = Container(
      height: dotSize,
      width: dotSize,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: color,
      ),
    );

    return Row(
      children: [
        if (dotDirection == AxisDirection.left) dot,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              label,
              softWrap: true,
              style: labelStyle,
              textAlign: dotDirection == AxisDirection.right ? TextAlign.right : TextAlign.left,
              maxLines: labelMaxLines,
            ),
          ),
        ),
        if (dotDirection == AxisDirection.right) dot,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);
    final theme = RideCalendarTheme.fromPlatform(context);

    final rowHeight = labelMaxHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: rowHeight,
          child: Row(
            children: [
              Expanded(
                child: _buildLegendItem(
                  color: theme.selection,
                  dotDirection: AxisDirection.right,
                  label: translator.currentSelection,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLegendItem(
                  color: theme.futureRide,
                  dotDirection: AxisDirection.left,
                  label: translator.futureRide,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: rowHeight,
          child: Row(
            children: [
              Expanded(
                child: _buildLegendItem(
                  color: theme.pastRide,
                  dotDirection: AxisDirection.right,
                  label: translator.pastDayWithRide,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLegendItem(
                  color: theme.pastDay,
                  dotDirection: AxisDirection.left,
                  label: translator.pastDayNoRide,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
