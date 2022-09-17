import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class provides the application [ThemeData].
abstract class ApplicationTheme {
  /// Primary / Secondary Theme colors.
  /// The primary color is defined as a [MaterialColor].
  static const MaterialColor primaryColor = Colors.blue;

  static const Color secondaryColor = Color(0xFF64B5F6);

  // ==== Device Picker Theme

  static const Color deviceIconColor = Colors.blue;
  static final Color deviceTypePickerDotColor = Colors.blue.shade100;
  static const Color deviceTypePickerCurrentDotColor = Colors.blue;

  // ==== DeviceListTheme

  /// The member devices list header + button color for android.
  static const Color memberDevicesListHeaderAddDeviceButtonColor = Colors.blue;

  /// The member devices list header + button colors for IOS.
  static const memberDevicesListHeaderAddDeviceButtonIdleColor = Colors.blue;
  static final memberDevicesListHeaderAddDeviceButtonPressedColor =
      Colors.blue.shade100;
  static const memberDevicesListHeaderTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  /// The member device item edit button color for android.
  static final Color memberDevicesListEditDeviceColor = Colors.blue.shade300;

  /// The member device item edit button colors for IOS.
  static final memberDevicesListEditDeviceIdleColor = Colors.blue.shade300;
  static final memberDevicesListEditDevicePressedColor = Colors.blue.shade100;

  // ==== Settings theme

  static const settingsOptionHeaderStyle = TextStyle(fontSize: 14);
  static final settingsScanSliderThumbColor = Colors.blue.shade300;
  static const settingsResetRideCalendarDescriptionTextStyle = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
  );

  static const appVersionTextStyle = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 12,
  );

  // ==== Scan Theme + Stepper sub theme

  static final androidScanStepperCurrentColor = Colors.lightGreen.shade200;
  static const androidScanStepperOtherColor = Colors.white;
  static final androidScanStepperArrowColor = Colors.lightBlue.shade200;

  static const iosScanStepperCurrentColor = CupertinoColors.activeGreen;
  static const iosScanStepperOtherColor = CupertinoColors.inactiveGray;
  static const iosScanStepperArrowColor = CupertinoColors.activeBlue;

  static const androidScanProgressColor = Color.fromARGB(255, 98, 204, 98);
  static const androidScanProgressBackground = Color.fromARGB(120, 98, 204, 98);

  static const iosScanProgressColor = CupertinoColors.activeGreen;
  static final iosScanProgressBackground =
      CupertinoColors.activeGreen.withOpacity(0.4);

  static const Color rideAttendeeScanResultSingleOwnerColor = Colors.blue;
  static const Color multipleOwnerColor = Colors.orange;
  static const Color rideAttendeeScanResultOwnerChoiceRequiredBackgroundColor =
      Colors.red;
  static const Color rideAttendeeScanResultOwnerChoiceRequiredFontColor =
      Colors.white;
  static final Color androidManualSelectionSwitchActiveTrackColor =
      Colors.lightBlue.shade200;

  static const Color androidManualSelectionSaveButtonPrimaryColor =
      Color(0xFF1666a5);

  static const multipleOwnersLabelStyle = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 12,
    color: multipleOwnerColor,
  );

  /// The background color for a selected ride attendee.
  static final Color rideAttendeeSelectedBackgroundColor = Colors.blue.shade700;

  static const rideAttendeeScanResultFirstNameTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
  );
  static const multipleOwnersListTooltipStyle = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 12,
    color: Colors.grey,
  );

  // ==== Miscellaneous stuff

  /// This color is used for Icons in lists that show some information
  /// when there is nothing to show.
  static const Color listInformationalIconColor = primaryColor;

  static const Color deleteItemButtonTextColor = Colors.red;

  static const importWarningTextStyle = TextStyle(color: Colors.red);

  static const Color importMembersDoneIconColor = Colors.green;

  static const Color rideListItemEvenMonthColor = Colors.blue;

  /// The text style for android form errors.
  static const androidFormErrorStyle = TextStyle(
    fontSize: 16,
    color: Colors.red,
  );

  // The text style for iOS form errors.
  static const iosFormErrorStyle = TextStyle(
    fontSize: 14,
    color: CupertinoColors.destructiveRed,
  );

  /// The text style for iOS buttons.
  static const TextStyle iosButtonTextStyle = TextStyle(color: primaryColor);

  static const androidRideAttendeeListCounterTextStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.white,
  );

  /// The Android theme.
  static ThemeData androidTheme() {
    return ThemeData(
      splashColor: secondaryColor.withAlpha(150),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: primaryColor,
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: primaryColor,
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
      ).copyWith(secondary: secondaryColor),
    );
  }

  /// The iOS theme.
  static CupertinoThemeData iosTheme() {
    return const CupertinoThemeData(
      primaryColor: primaryColor,
      primaryContrastingColor: secondaryColor,
    );
  }
}
