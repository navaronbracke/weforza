import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/add_ride_form_delegate.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar_item.dart';
import 'package:weforza/widgets/custom/date_picker/date_picker.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

class AddRideCalendar extends StatelessWidget {
  const AddRideCalendar({super.key, required this.delegate});

  final AddRideFormDelegate delegate;

  @override
  Widget build(BuildContext context) {
    final calendarDelegate = delegate.calendarDelegate;

    final theme = RideCalendarTheme.fromPlatform(context);

    return DatePicker(
      // Use the smallest size for now.
      computeDaySize: (constraints) => constraints.smallest,
      dayBuilder: (day, isCurrentMonth, size) {
        if (isCurrentMonth) {
          return AddRideCalendarItem(
            date: day,
            delegate: delegate,
            size: size,
            theme: theme,
          );
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
  const _AddRideCalendarHeaderButton(
    this.onPressed,
    this.buttonSize,
    this.axis,
  ) : assert(axis == AxisDirection.left || axis == AxisDirection.right);

  final AxisDirection axis;

  final double buttonSize;

  final void Function() onPressed;

  IconData _getIconForAxis({
    required IconData backIcon,
    required IconData forwardIcon,
  }) {
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
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return IconButton(
          icon: Icon(
            _getIconForAxis(
              backIcon: Icons.arrow_back,
              forwardIcon: Icons.arrow_forward,
            ),
          ),
          onPressed: onPressed,
          // Enforce the icon constraints to match the button size.
          constraints: BoxConstraints(
            minHeight: buttonSize,
            minWidth: buttonSize,
          ),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoIconButton(
          icon: _getIconForAxis(
            backIcon: CupertinoIcons.chevron_left,
            forwardIcon: CupertinoIcons.chevron_right,
          ),
          size: buttonSize,
          onPressed: onPressed,
        );
    }
  }
}
