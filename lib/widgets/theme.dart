import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class defines the application theme.
abstract class AppTheme {
  /// The [ThemeData] for the [MaterialApp].
  static final androidTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    chipTheme: const ChipThemeData(
      selectedColor: Colors.blue,
      secondaryLabelStyle: TextStyle(color: Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );

  /// The theme for destructive actions, such as delete buttons.
  static final desctructiveAction = DestructiveActionTheme();

  /// The device type picker theme.
  static final deviceTypePicker = DeviceTypePickerThemes();

  /// The [CupertinoThemeData] for the [CupertinoApp].
  static const iosTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
  );

  /// The theme for the bottom bar on the manual selection.
  static const manualSelectionBottomBar = ManualSelectionBottomBarTheme();

  /// The member devices list theme.
  static const memberDevicesList = MemberDeviceListTheme();

  /// The member list item theme.
  static const memberListItem = MemberListItemTheme();

  /// The ride attendee scan results theme.
  static const rideAttendeeScanResult = RideAttendeeScanResultThemes();

  /// The ride calendar theme.
  static const rideCalendar = RideCalendarTheme();

  /// The theme for the scan progress indicator.
  static const scanProgressIndicator = ScanProgressIndicatorTheme();

  /// The theme for the scan stepper.
  static const scanStepper = ScanStepperThemes();
}

/// This class represents the theme for destructive action buttons.
class DestructiveActionTheme {
  /// The default text style for Android error messages.
  final androidDefaultErrorStyle = const TextStyle(color: Colors.red);

  /// The medium text style for Android error messages.
  final androidMediumErrorStyle = const TextStyle(
    fontSize: 16,
    color: Colors.red,
  );

  /// The theme for destructive [ElevatedButton]s.
  final elevatedButtonTheme = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
  );

  /// The theme for destructive [TextButton]s.
  final textButtonTheme = TextButton.styleFrom(foregroundColor: Colors.red);
}

/// This class represents the data for [DeviceTypePickerThemes].
class DeviceTypePickerTheme {
  const DeviceTypePickerTheme({
    required this.selectedColor,
    required this.unselectedColor,
  });

  /// The color for a selected device type.
  final Color selectedColor;

  /// The color for an unselected device type.
  final Color unselectedColor;
}

/// This class represents the theme for the device type picker.
class DeviceTypePickerThemes {
  DeviceTypePickerThemes();

  /// The device type picker theme for Android.
  final android = DeviceTypePickerTheme(
    selectedColor: Colors.blue,
    unselectedColor: Colors.blue.shade100,
  );

  /// The device type picker theme for iOS.
  final ios = const DeviceTypePickerTheme(
    selectedColor: CupertinoColors.activeBlue,
    unselectedColor: CupertinoColors.systemGrey4,
  );
}

/// This class represents the theme for the bottom bar
/// on the manual ride attendee selection page.
///
/// This theme is only used on Android, as iOS uses the system defaults to
/// style its widgets.
class ManualSelectionBottomBarTheme {
  const ManualSelectionBottomBarTheme();

  /// The primary color for the save button.
  final Color saveButtonColor = const Color(0xFF1666a5);

  /// The active track color for the filter switch.
  final Color switchActiveTrackColor = const Color(0xFF81D4FA);
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

/// This class represents the theme for the ride calendar date picker.
class RideCalendarTheme {
  const RideCalendarTheme();

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

/// This class represents the data for a [RideAttendeeScanResultThemes] sub theme.
class RideAttendeeScanResultTheme {
  const RideAttendeeScanResultTheme({
    required this.multipleOwnersDescriptionStyle,
    required this.multipleOwnersLabelStyle,
    required this.selectedBackgroundColor,
    required this.singleOwnerColor,
  });

  /// The style for the multiple owners description label.
  final TextStyle multipleOwnersDescriptionStyle;

  /// The style for the multiple owners label.
  final TextStyle multipleOwnersLabelStyle;

  /// The background color for a selected item.
  final Color selectedBackgroundColor;

  /// The color for a scan result that has a single owner.
  final Color singleOwnerColor;
}

/// This class represents the theme for ride attendee scan results.
class RideAttendeeScanResultThemes {
  const RideAttendeeScanResultThemes();

  /// The scan result theme for Android.
  final android = const RideAttendeeScanResultTheme(
    multipleOwnersDescriptionStyle: TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 12,
      color: Colors.grey,
    ),
    multipleOwnersLabelStyle: TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 12,
      color: Colors.orange,
    ),
    selectedBackgroundColor: Color(0xFF1976D2),
    singleOwnerColor: Colors.blue,
  );

  /// The scan result theme for iOS.
  final ios = const RideAttendeeScanResultTheme(
    multipleOwnersDescriptionStyle: TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 12,
      color: CupertinoColors.systemGrey,
    ),
    multipleOwnersLabelStyle: TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 12,
      color: CupertinoColors.activeOrange,
    ),
    selectedBackgroundColor: CupertinoColors.activeBlue,
    singleOwnerColor: CupertinoColors.activeBlue,
  );
}
