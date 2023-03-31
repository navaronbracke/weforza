import 'package:flutter/material.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarItem.dart';

class AddRideCalendarMonth extends StatelessWidget {
  AddRideCalendarMonth({
    required this.pageDate,
    required this.daysInMonth,
    required ValueKey<DateTime> key,
    required this.register,
    required this.unregister,
    required this.onTap,
    required this.isBeforeToday,
    required this.rideScheduledDuringCurrentSession,
    required this.rideScheduledOn,
  }): super(key: key);

  final DateTime pageDate;
  final int daysInMonth;

  /// See [AddRideCalendarItem].
  final void Function(void Function() resetFunction) register;

  /// See [AddRideCalendarItem].
  final void Function(void Function() resetFunction) unregister;

  /// See [AddRideCalendarItem].
  final bool Function(DateTime date) onTap;

  /// See [AddRideCalendarItem].
  final bool Function(DateTime date) isBeforeToday;

  /// See [AddRideCalendarItem].
  final bool Function(DateTime date) rideScheduledOn;

  /// See [AddRideCalendarItem].
  final bool Function(DateTime date) rideScheduledDuringCurrentSession;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: _buildCalendarRows(),
  );

  List<Widget> _buildCalendarRows() {
    //Calculate the start offset
    //If the first day of the month is monday, this is 0. If this day is a sunday, its 6.
    int offset = pageDate.weekday - 1;
    //A list of filler widgets for the offset + the actual day widgets
    List<Widget> items = [];
    //Add start offset widgets first
    for (int i = 0; i < offset; i++) {
      items.add(SizedBox.fromSize(size: Size.square(40)));
    }

    //Add days of month
    for (int i = 0; i < daysInMonth; i++) {
      items.add(
        AddRideCalendarItem(
          date: DateTime(pageDate.year, pageDate.month, i + 1),
          onTap: onTap,
          isBeforeToday: isBeforeToday,
          rideScheduledDuringCurrentSession: rideScheduledDuringCurrentSession,
          rideScheduledOn: rideScheduledOn,
          register: register,
          unregister: unregister,
        ),
      );
    }
    // Calculate the end offset.
    // If the last day of the displayed month is a sunday, this is 0.
    // If it is a monday it is 6.
    offset = 7 - DateTime(pageDate.year, pageDate.month, daysInMonth).weekday;

    // Add end-offset widgets at the end of the list.
    for (int i = 0; i < offset; i++) {
      items.add(SizedBox.fromSize(size: Size.square(40)));
    }

    // The aforementioned items, but grouped in rows.
    List<Widget> output = [];

    // While we still have items to put in rows, generate a row.
    while (items.isNotEmpty) {
      List<Widget> children = [];

      if (items.length < 7) {
        // Add remaining items.
        while (items.isNotEmpty) {
          children.add(items.removeAt(0));
        }
      } else {
        // Add an entire week of items.
        for (int i = 0; i < 7; i++) {
          children.add(items.removeAt(0));
        }
      }

      output.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Row(
          children: children,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ));
    }

    return output;
  }
}
