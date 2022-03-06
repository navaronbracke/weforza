import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';

class AddRideCalendarItem extends StatefulWidget {
  const AddRideCalendarItem({
    Key? key,
    required this.date,
    required this.register,
    required this.unregister,
    required this.onTap,
    required this.isBeforeToday,
    required this.rideScheduledDuringCurrentSession,
    required this.rideScheduledOn,
  }) : super(key: key);

  /// The date for the calendar item.
  final DateTime date;

  /// Register the given reset function.
  /// This allows the given function to be called from a parent widget.
  final void Function(void Function() resetFunction) register;

  /// Unregister the given reset function.
  /// This is meant as cleanup during dispose().
  final void Function(void Function() resetFunction) unregister;

  /// The onTap function for the item.
  /// Returns true if the item can be used in a click gesture.
  final bool Function(DateTime date) onTap;

  /// This function determines if the given date is before 'today'.
  /// This is a parameter, as 'today' is a fixed value.
  final bool Function(DateTime date) isBeforeToday;

  /// This function determines if there is a ride scheduled for the given date.
  final bool Function(DateTime date) rideScheduledOn;

  /// This function determines if there is a ride scheduled for the given date,
  /// and this ride was scheduled in the current session.
  /// I.e. The ride on this date was scheduled in the current session
  /// and not in a previous session.
  final bool Function(DateTime date) rideScheduledDuringCurrentSession;

  @override
  _AddRideCalendarItemState createState() => _AddRideCalendarItemState();
}

class _AddRideCalendarItemState extends State<AddRideCalendarItem> {
  late Color _backgroundColor;
  late Color _fontColor;

  ///The on reset callback
  late VoidCallback _onReset;

  @override
  void initState() {
    super.initState();
    _onReset = () {
      if (mounted) setState(_setColors);
    };
    widget.register(_onReset);
    _setColors();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Update the widget if allowed.
        if (mounted && widget.onTap(widget.date)) {
          setState(() {
            _setColors();
          });
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Text(
            '${widget.date.day}',
            style: TextStyle(color: _fontColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  ///Update the colors for the widget.
  void _setColors() {
    // In the past.
    if (widget.isBeforeToday(widget.date)) {
      // A day in the past that had a ride.
      if (widget.rideScheduledOn(widget.date)) {
        // A day in the past that just got a ride scheduled in the current session.
        if (widget.rideScheduledDuringCurrentSession(widget.date)) {
          _backgroundColor =
              ApplicationTheme.rideCalendarSelectedDayBackgroundColor;
          _fontColor = ApplicationTheme.rideCalendarDayFontColor;
        } else {
          // A day in the past that had a ride.
          // The ride was scheduled in a different session.
          _backgroundColor =
              ApplicationTheme.rideCalendarPastDayWithRideBackgroundColor;
          _fontColor = ApplicationTheme.rideCalendarDayFontColor;
        }
      } else {
        // A day in the past that didn't have a ride.
        _backgroundColor =
            ApplicationTheme.rideCalendarPastDayWithoutRideBackgroundColor;
        _fontColor = ApplicationTheme.rideCalendarDayFontColor;
      }
    } else {
      // A day with a ride.
      if (widget.rideScheduledOn(widget.date)) {
        // A day in the future (or today) that just got a ride scheduled in the current session.
        if (widget.rideScheduledDuringCurrentSession(widget.date)) {
          _backgroundColor =
              ApplicationTheme.rideCalendarSelectedDayBackgroundColor;
          _fontColor = ApplicationTheme.rideCalendarDayFontColor;
        } else {
          // A day in the future (or today) that
          // already had a ride scheduled in a different session.
          _backgroundColor =
              ApplicationTheme.rideCalendarFutureDayWithRideBackgroundColor;
          _fontColor = ApplicationTheme.rideCalendarDayFontColor;
        }
      } else {
        // A day in the future (or today) that does not have a ride scheduled.
        _backgroundColor =
            Colors.transparent; // Use the background color of the page.
        _fontColor = ApplicationTheme.rideCalendarFutureDayNoRideFontColor;
      }
    }
  }

  @override
  void dispose() {
    widget.unregister(_onReset);
    super.dispose();
  }
}
