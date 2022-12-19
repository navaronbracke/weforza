import 'package:flutter/material.dart';
import 'package:weforza/model/add_ride_form_delegate.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

class AddRideCalendarItem extends StatelessWidget {
  const AddRideCalendarItem({
    super.key,
    required this.date,
    required this.delegate,
    required this.size,
    required this.theme,
  });

  /// The date for the calendar item.
  final DateTime date;

  /// The delegate that manages the selection.
  final AddRideFormDelegate delegate;

  /// The size of this calendar item.
  final Size size;

  /// The theme for this ride calendar item.
  final RideCalendarTheme theme;

  Color? _computeBackgroundColor() {
    if (delegate.isBeforeToday(date)) {
      // A day in the past that has a ride.
      if (delegate.isScheduled(date)) {
        // The ride was scheduled in the current session.
        if (delegate.isScheduled(date, inCurrentSession: true)) {
          return theme.selection;
        }

        return theme.pastRide;
      }

      // A day in the past that doesn't have a ride.
      return theme.pastDay;
    }

    // A day in the future (or today) that has a ride scheduled.
    if (delegate.isScheduled(date)) {
      // The ride was scheduled in the current session.
      if (delegate.isScheduled(date, inCurrentSession: true)) {
        return theme.selection;
      }

      return theme.futureRide;
    }

    // A day in the future (or today) that doesn't have a ride.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<DateTime>>(
      initialData: delegate.currentSelection,
      stream: delegate.selection,
      builder: (context, _) {
        final style = delegate.isBeforeToday(date) || delegate.isScheduled(date)
            ? const TextStyle(color: Colors.white)
            : null;

        return GestureDetector(
          onTap: () => delegate.onDaySelected(date),
          child: SizedBox.fromSize(
            size: size,
            child: Padding(
              padding: theme.padding,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _computeBackgroundColor(),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
