import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/add_ride_page_delegate.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar_item.dart';
import 'package:weforza/widgets/custom/date_picker/date_picker.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';

class AddRideCalendar extends StatelessWidget {
  const new({required this.delegate, super.key});

  final AddRidePageDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      // Use the smallest size for now.
      computeDaySize: (constraints) => constraints.smallest,
      dayBuilder: (day, size, {bool isCurrentMonth = false}) {
        if (isCurrentMonth) {
          return AddRideCalendarItem(date: day, delegate: delegate, size: size);
        }

        return SizedBox.fromSize(size: size);
      },
      delegate: delegate.calendarDelegate,
      headerButtonBuilder: _AddRideCalendarHeaderButton.new,
      showWeekdays: true,
    );
  }
}

class _AddRideCalendarHeaderButton extends StatelessWidget {
  const new(this.onPressed, this.buttonSize, this.axis)
    : assert(axis == .left || axis == .right, 'The axis should be AxisDirection.left or AxisDirection.right');

  final AxisDirection axis;

  final double buttonSize;

  final void Function() onPressed;

  IconData _getIconForAxis({required IconData backIcon, required IconData forwardIcon}) {
    return switch (axis) {
      .left => backIcon,
      .right => forwardIcon,
      .down || .up => throw ArgumentError.value(axis),
    };
  }

  @override
  Widget build(BuildContext context) {
    return switch (defaultTargetPlatform) {
      .android || .fuchsia || .linux || .windows => IconButton(
        icon: Icon(_getIconForAxis(backIcon: Icons.arrow_back, forwardIcon: Icons.arrow_forward)),
        onPressed: onPressed,
        // Enforce the icon constraints to match the button size.
        constraints: BoxConstraints(minHeight: buttonSize, minWidth: buttonSize),
      ),
      .iOS || .macOS => CupertinoIconButton(
        icon: _getIconForAxis(backIcon: CupertinoIcons.chevron_left, forwardIcon: CupertinoIcons.chevron_right),
        size: buttonSize,
        onPressed: onPressed,
      ),
    };
  }
}
