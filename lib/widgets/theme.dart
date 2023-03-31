import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This class defines the application theme.
abstract class AppTheme {
  /// The device type picker theme.
  static const deviceTypePicker = DeviceTypePickerTheme();

  /// The member devices list theme.
  static const memberDevicesList = MemberDeviceListTheme();

  /// The member list item theme.
  static const memberListItem = MemberListItemTheme();

  /// The profile image placeholder theme.
  static const profileImagePlaceholder = ProfileImagePlaceholderTheme();

  /// The ride calendar theme.
  static const rideCalendar = RideCalendarTheme();

  /// The theme for the scan progress indicator.
  static const scanProgressIndicator = ScanProgressIndicatorTheme();

  /// The theme for the scan stepper.
  static const scanStepper = ScanStepperThemes();

  /// The theme for the settings page.
  static const settings = SettingsTheme();
}

/// This class represents the theme for the device type picker.
class DeviceTypePickerTheme {
  const DeviceTypePickerTheme();

  /// The color for a selected device type.
  final Color selectedColor = Colors.blue;

  /// The color for an unselected device type.
  final Color unselectedColor = const Color(0xFFBBDEFB);
}

/// This class represents the theme for the member devices list.
class MemberDeviceListTheme {
  const MemberDeviceListTheme();

  /// The color for the edit device button on Android.
  /// iOS uses a [CupertinoColors] value to resolve a color.
  final Color androidEditDeviceButtonColor = const Color(0xFF64B5F6);

  /// The text style for the member devices list header.
  final TextStyle headerStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}

/// This class defines the theme for member list items.
class MemberListItemTheme {
  const MemberListItemTheme();

  /// The text style for the first name.
  final TextStyle firstNameStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  /// The text style for the last name.
  final TextStyle lastNameStyle = const TextStyle(fontSize: 14);
}

/// This class represents the theme for the profile image placeholder.
class ProfileImagePlaceholderTheme {
  const ProfileImagePlaceholderTheme();

  /// The background color for the profile image placeholder.
  final Color backgroundColor = const Color(0xFF1976D2);

  /// The icon color for the profile image placeholder.
  final Color iconColor = Colors.white;

  /// The text style for the displayed initials.
  final TextStyle initialsStyle = const TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
  );
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

/// This class represents the data for a [ScanProgressIndicatorTheme] sub theme.
class _ScanProgressIndicatorTheme {
  const _ScanProgressIndicatorTheme({
    required this.backgroundColor,
    required this.progressColor,
  });

  /// The background color for the progress indicator.
  final Color backgroundColor;

  /// The color for the progress in the progress indicator.
  final Color progressColor;
}

/// This class represents the theme for a scan progress indicator.
class ScanProgressIndicatorTheme {
  const ScanProgressIndicatorTheme();

  /// The theme for the Android progress indicator.
  final android = const _ScanProgressIndicatorTheme(
    backgroundColor: Color(0x7862CC62),
    progressColor: Color(0xFF62CC62),
  );

  /// The theme for the iOS progress indicator.
  final ios = const _ScanProgressIndicatorTheme(
    // This color is equal to `systemGreen.withOpacity(0.4)`
    backgroundColor: Color(0x6634C759),
    progressColor: CupertinoColors.systemGreen,
  );
}

/// This class represents the data for a [ScanStepperTheme] sub theme.
class ScanStepperTheme {
  const ScanStepperTheme({
    required this.active,
    required this.arrow,
    required this.inactive,
  });

  /// The color for the active step.
  final Color active;

  /// The icon for the arrow.
  final Icon arrow;

  /// The color for inactive steps.
  final Color inactive;
}

/// This class represents the theme for a scan stepper.
class ScanStepperThemes {
  const ScanStepperThemes();

  /// The theme for the Android stepper.
  final android = const ScanStepperTheme(
    active: Color(0xFFC5E1A5),
    arrow: Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF81D4FA)),
    inactive: Colors.white,
  );

  /// The theme for the iOS stepper.
  final ios = const ScanStepperTheme(
    active: CupertinoColors.activeGreen,
    arrow: Icon(
      CupertinoIcons.chevron_forward,
      color: CupertinoColors.activeBlue,
    ),
    inactive: CupertinoColors.inactiveGray,
  );
}

/// This class represents the theme for the settings page.
class SettingsTheme {
  const SettingsTheme();

  /// The text style for the header of a settings option.
  final TextStyle optionHeaderStyle = const TextStyle(fontSize: 14);

  /// The text style for the description below a settings option.
  final TextStyle optionDescriptionStyle = const TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
  );
}
