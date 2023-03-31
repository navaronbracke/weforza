import 'package:flutter/material.dart';

/// This class defines the application theme.
abstract class AppTheme {
  /// The profile image placeholder theme.
  static const profileImagePlaceholder = ProfileImagePlaceholderTheme();

  /// The ride calendar theme.
  static const rideCalendar = RideCalendarTheme();
}

/// This class represents the theme for the profile image placeholder.
class ProfileImagePlaceholderTheme {
  const ProfileImagePlaceholderTheme();

  /// The background color for the profile image placeholder.
  final Color backgroundColor = const Color(0xFF1976D2);

  /// The icon color for the profile image placeholder.
  final Color iconColor = Colors.white;
}

/// This class represents the theme for the ride calendar date picker.
class RideCalendarTheme {
  const RideCalendarTheme();

  /// The color for the change month buttons in the header.
  final Color changeMonthButton = Colors.black;

  /// The color for a planned ride that is in the future.
  final Color futureRide = const Color(0xFF1976D2);

  /// The color for a day that is in the past, which had no ride scheduled.
  final Color pastDay = const Color(0xFFBDBDBD);

  /// The color for a day that is in the past, which had a ride scheduled.
  final Color pastRide = const Color(0xFF616161);

  /// The text style for a day that has a ride scheduled,
  /// regardless if this day is in the past, in the future
  /// or in the current selection of days.
  final TextStyle scheduledDayStyle = const TextStyle(color: Colors.white);

  /// The text style for a day that can be scheduled.
  final TextStyle selectableDayStyle = const TextStyle(color: Colors.black);

  /// The color for a day that is currently selected.
  final Color selectedDay = const Color(0xFF90CAF9);
}
