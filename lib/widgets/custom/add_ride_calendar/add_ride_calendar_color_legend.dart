import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_calendar_item_state.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

/// This widget represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  const AddRideCalendarColorLegend({super.key});

  @override
  Widget build(BuildContext context) {
    const rowHeight = _AddRideCalendarColorLegendItem.labelMaxHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: rowHeight,
          child: Row(
            children: [
              Expanded(
                child: _AddRideCalendarColorLegendItem(
                  dotDirection: AxisDirection.right,
                  state: RideCalendarItemState.currentSelection,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _AddRideCalendarColorLegendItem(
                  dotDirection: AxisDirection.left,
                  state: RideCalendarItemState.futureRide,
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
                child: _AddRideCalendarColorLegendItem(
                  dotDirection: AxisDirection.right,
                  state: RideCalendarItemState.pastRide,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _AddRideCalendarColorLegendItem(
                  dotDirection: AxisDirection.left,
                  state: RideCalendarItemState.pastDay,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddRideCalendarColorLegendItem extends StatelessWidget {
  const _AddRideCalendarColorLegendItem({
    required this.dotDirection,
    required this.state,
  }) : assert(
          dotDirection == AxisDirection.left || dotDirection == AxisDirection.right,
          'The dot direction of a legend item should be AxisDirection.left or AxisDirection.right',
        );

  /// The size of the dot next to a label.
  static const double dotSize = 20;

  /// The font size for the legend label.
  static const double labelFontSize = 14;

  /// The maximum height for the legend label.
  static const double labelMaxHeight = labelFontSize * labelMaxLines;

  /// The max lines for a label of a legend item.
  static const int labelMaxLines = 2;

  /// The text style for a label of a legend item.
  ///
  /// This style has a fixed [TextStyle.height], so that the total height of
  /// a label item can be computed by the [labelMaxHeight] getter.
  static const TextStyle labelStyle = TextStyle(fontSize: labelFontSize, height: 1);

  /// The direction of the legend item dot.
  final AxisDirection dotDirection;

  /// The state that this legend item represents.
  final RideCalendarItemState state;

  String _getLabel(BuildContext context) {
    final translator = S.of(context);

    switch (state) {
      case RideCalendarItemState.currentSelection:
        return translator.currentSelection;
      case RideCalendarItemState.futureRide:
        return translator.futureRide;
      case RideCalendarItemState.pastDay:
        return translator.pastDayNoRide;
      case RideCalendarItemState.pastRide:
        return translator.pastDayWithRide;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      height: dotSize,
      width: dotSize,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: RideCalendarTheme.resolve(context, state: state).backgroundColor,
      ),
    );

    return Row(
      children: [
        if (dotDirection == AxisDirection.left) dot,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              _getLabel(context),
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
}
