import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_calendar_item_state.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

/// This widget represents a color legend for AddRidePage.
class AddRideCalendarColorLegend extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    const rowHeight = _AddRideCalendarColorLegendItem.labelMaxHeight;

    return const Column(
      mainAxisSize: .min,
      children: [
        SizedBox(
          height: rowHeight,
          child: Row(
            children: [
              Expanded(
                child: _AddRideCalendarColorLegendItem(dotDirection: .right, state: .currentSelection),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _AddRideCalendarColorLegendItem(dotDirection: .left, state: .futureRide),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          height: rowHeight,
          child: Row(
            children: [
              Expanded(
                child: _AddRideCalendarColorLegendItem(dotDirection: .right, state: .pastRide),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _AddRideCalendarColorLegendItem(dotDirection: .left, state: .pastDay),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddRideCalendarColorLegendItem extends StatelessWidget {
  const new({required this.dotDirection, required this.state})
    : assert(
        dotDirection == .left || dotDirection == .right,
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

    return switch (state) {
      .currentSelection => translator.currentSelection,
      .futureRide => translator.futureRide,
      .pastDay => translator.pastDayNoRide,
      .pastRide => translator.pastDayWithRide,
    };
  }

  @override
  Widget build(BuildContext context) {
    final BoxDecoration? decoration = RideCalendarTheme.resolve(context, state: state).decoration;

    final dot = Container(
      height: dotSize,
      width: dotSize,
      decoration: decoration?.copyWith(borderRadius: const .all(.circular(10))),
    );

    return Row(
      children: [
        if (dotDirection == .left) dot,
        Expanded(
          child: Padding(
            padding: const .symmetric(horizontal: 6),
            child: Text(
              _getLabel(context),
              softWrap: true,
              style: labelStyle,
              textAlign: dotDirection == .right ? .right : .left,
              maxLines: labelMaxLines,
            ),
          ),
        ),
        if (dotDirection == .right) dot,
      ],
    );
  }
}
