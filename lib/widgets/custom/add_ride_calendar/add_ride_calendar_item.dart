import 'package:flutter/material.dart';
import 'package:weforza/model/add_ride_page_delegate.dart';
import 'package:weforza/model/ride_calendar_item_state.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

class AddRideCalendarItem extends StatelessWidget {
  const AddRideCalendarItem({required this.date, required this.delegate, required this.size, super.key});

  /// The date for the calendar item.
  final DateTime date;

  /// The delegate that manages the selection.
  final AddRidePageDelegate delegate;

  /// The size of this calendar item.
  final Size size;

  RideCalendarItemState? _getStateForItem() {
    if (delegate.isBeforeToday(date)) {
      // The ride was scheduled in the current session.
      if (delegate.isScheduled(date, inCurrentSession: true)) {
        return RideCalendarItemState.currentSelection;
      }

      // A day in the past that had a ride, which was scheduled in an earlier session.
      if (delegate.isScheduled(date)) {
        return RideCalendarItemState.pastRide;
      }

      // A day in the past that doesn't have a ride.
      return RideCalendarItemState.pastDay;
    }

    // A day in the future (or today) that has a ride scheduled.
    if (delegate.isScheduled(date)) {
      // The ride was scheduled in the current session.
      if (delegate.isScheduled(date, inCurrentSession: true)) {
        return RideCalendarItemState.currentSelection;
      }

      // A day in the future that has a ride, which was scheduled in an earlier session.
      return RideCalendarItemState.futureRide;
    }

    // A day in the future (or today) that doesn't have a ride.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<DateTime>>(
      initialData: delegate.currentSelection,
      stream: delegate.selectionStream,
      builder: (context, _) {
        final theme = RideCalendarTheme.resolve(context, state: _getStateForItem());
        final decoration = theme.decoration;

        Widget child = Center(child: Text('${date.day}', style: theme.textStyle, textAlign: TextAlign.center));

        if (decoration != null) {
          child = DecoratedBox(decoration: decoration, child: child);
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => delegate.selectDay(date),
          child: SizedBox.fromSize(size: size, child: Padding(padding: const EdgeInsets.all(4), child: child)),
        );
      },
    );
  }
}
