import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/add_ride_page_delegate.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar_item.dart';
import 'package:weforza/widgets/custom/date_picker/date_picker.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';

class AddRideCalendar extends StatelessWidget {
  const AddRideCalendar({required this.delegate, super.key});

  final AddRidePageDelegate delegate;

  @override
  Widget build(BuildContext context) {
    final calendarDelegate = delegate.calendarDelegate;

    return DatePicker(
      // Use the smallest size for now.
      computeDaySize: (constraints) => constraints.smallest,
      dayBuilder: (day, size, {bool isCurrentMonth = false}) {
        if (isCurrentMonth) {
          return AddRideCalendarItem(date: day, delegate: delegate, size: size);
        }

        return SizedBox.fromSize(size: size);
      },
      delegate: calendarDelegate,
      headerButtonBuilder: _AddRideCalendarHeaderButton.new,
      showWeekdays: true,
    );
  }
}

class _AddRideCalendarHeaderButton extends StatelessWidget {
  const _AddRideCalendarHeaderButton(this.onPressed, this.buttonSize, this.axis)
    : assert(
        axis == AxisDirection.left || axis == AxisDirection.right,
        'The axis should be AxisDirection.left or AxisDirection.right',
      );

  final AxisDirection axis;

  final double buttonSize;

  final void Function() onPressed;

  IconData _getIconForAxis({required IconData backIcon, required IconData forwardIcon}) {
    switch (axis) {
      case AxisDirection.left:
        return backIcon;
      case AxisDirection.right:
        return forwardIcon;
      case AxisDirection.down:
      case AxisDirection.up:
        throw ArgumentError.value(axis);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return IconButton(
          icon: Icon(_getIconForAxis(backIcon: Icons.arrow_back, forwardIcon: Icons.arrow_forward)),
          onPressed: onPressed,
          // Enforce the icon constraints to match the button size.
          constraints: BoxConstraints(minHeight: buttonSize, minWidth: buttonSize),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoIconButton(
          icon: _getIconForAxis(backIcon: CupertinoIcons.chevron_left, forwardIcon: CupertinoIcons.chevron_right),
          size: buttonSize,
          onPressed: onPressed,
        );
    }
  }
}
