import 'package:flutter/material.dart';
import 'package:weforza/model/add_ride_form_delegate.dart';
import 'package:weforza/theme/app_theme.dart';

class AddRideCalendarItem extends StatelessWidget {
  const AddRideCalendarItem({
    super.key,
    required this.date,
    required this.delegate,
  });

  /// The date for the calendar item.
  final DateTime date;

  /// The delegate that manages the selection.
  final AddRideFormDelegate delegate;

  Color? _computeBackgroundColor() {
    if (delegate.isBeforeToday(date)) {
      // A day in the past that has a ride.
      if (delegate.isScheduled(date)) {
        // The ride was scheduled in the current session.
        if (delegate.isScheduled(date, inCurrentSession: true)) {
          return ApplicationTheme.rideCalendarSelectedDayBackgroundColor;
        }

        return ApplicationTheme.rideCalendarPastDayWithRideBackgroundColor;
      }

      // A day in the past that doesn't have a ride.
      return ApplicationTheme.rideCalendarPastDayWithoutRideBackgroundColor;
    }

    // A day in the future (or today) that has a ride scheduled.
    if (delegate.isScheduled(date)) {
      // The ride was scheduled in the current session.
      if (delegate.isScheduled(date, inCurrentSession: true)) {
        return ApplicationTheme.rideCalendarSelectedDayBackgroundColor;
      }

      return ApplicationTheme.rideCalendarFutureDayWithRideBackgroundColor;
    }

    // A day in the future (or today) that doesn't have a ride.
    return null;
  }

  Color _computeFontColor() {
    if (delegate.isBeforeToday(date) || delegate.isScheduled(date)) {
      return ApplicationTheme.rideCalendarDayFontColor;
    }

    return ApplicationTheme.rideCalendarFutureDayNoRideFontColor;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<DateTime>>(
      initialData: delegate.currentSelection,
      stream: delegate.selection,
      builder: (context, _) {
        final backgroundColor = _computeBackgroundColor();

        return GestureDetector(
          onTap: () => delegate.onDaySelected(date),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(color: _computeFontColor()),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
