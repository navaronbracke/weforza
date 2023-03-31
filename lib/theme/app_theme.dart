import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class provides the application [ThemeData].
abstract class ApplicationTheme {
  /// Primary / Secondary Theme colors.
  /// The primary color is defined as a [MaterialColor].
  static const MaterialColor primaryColor = Colors.blue;
  static final Color secondaryColor = Colors.blue.shade300;

  /// The color for a calendar day
  /// that is now or in the future, which has no ride.
  static const Color rideCalendarFutureDayNoRideFontColor = Colors.black;

  /// The font color for a calendar day, except for future days without rides.
  static const Color rideCalendarDayFontColor = Colors.white;

  static final Color rideCalendarFutureDayWithRideBackgroundColor =
      Colors.blue.shade700;
  static final Color rideCalendarSelectedDayBackgroundColor =
      Colors.blue.shade200;
  static final Color rideCalendarPastDayWithoutRideBackgroundColor =
      Colors.grey.shade400;
  static final Color rideCalendarPastDayWithRideBackgroundColor =
      Colors.grey.shade700;

  /// The font color for the ride calendar header.
  static const Color rideCalendarHeaderColor = Colors.black;

  /// The color for a choice arrow.
  static const Color choiceArrowIdleColor = Colors.black;

  /// The pressed color for a choice arrow.
  static const Color choiceArrowOnPressedColor = Colors.black45;

  /// The profile image placeholder's icon color.
  static const Color profileImagePlaceholderIconColor = Colors.white;

  /// The profile image placeholder icon's background color.
  static final Color profileImagePlaceholderIconBackgroundColor =
      Colors.blue.shade700;

  /// The text style for a person's initials.
  static const TextStyle personInitialsTextStyle = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
  );

  /// The background color for an unselected ride attendee.
  static const Color rideAttendeeUnSelectedBackgroundColor = Colors.transparent;

  /// The background color for a selected ride attendee.
  static final Color rideAttendeeSelectedBackgroundColor = Colors.blue.shade700;

  /// The text style for the first name of an item in the member list.
  static const TextStyle memberListItemFirstNameTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  /// The text style for the last name of an item in the member list.
  static const memberListItemLastNameTextStyle = TextStyle(fontSize: 14);

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

  static const Color deviceIconColor = Colors.blue;
  static final Color deviceTypePickerDotColor = Colors.blue.shade100;
  static const Color deviceTypePickerCurrentDotColor = Colors.blue;

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

  /// This color is used for Icons in lists that show some information
  /// when there is nothing to show.
  static const Color listInformationalIconColor = primaryColor;

  static const settingsOptionHeaderStyle = TextStyle(fontSize: 14);
  static final settingsScanSliderThumbColor = Colors.blue.shade300;
  static const settingsResetRideCalendarDescriptionTextStyle = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
  );

  static final androidRideAttendeeScanProcessCurrentStepColor =
      Colors.lightGreen.shade200;
  static const androidRideAttendeeScanProcessOtherStepColor = Colors.white;
  static final androidRideAttendeeScanProcessArrowColor =
      Colors.lightBlue.shade200;
  static const iosRideAttendeeScanProcessCurrentStepColor =
      CupertinoColors.activeGreen;
  static const iosRideAttendeeScanProcessOtherStepColor =
      CupertinoColors.inactiveGray;
  static const iosRideAttendeeScanProcessArrowColor =
      CupertinoColors.activeBlue;
  static const androidRideAttendeeScanProgressbarColor =
      Color.fromARGB(255, 98, 204, 98);
  static const androidRideAttendeeScanProgressbarBackgroundColor =
      Color.fromARGB(120, 98, 204, 98);

  static const Color iosRideAttendeeScanProgressbarColor =
      CupertinoColors.activeGreen;
  static final Color iosRideAttendeeScanProgressbarBackgroundColor =
      CupertinoColors.activeGreen.withOpacity(0.4);

  static const Color rideAttendeeScanResultSingleOwnerColor = Colors.blue;
  static const Color rideAttendeeScanResultMultipleOwnerColor = Colors.orange;
  static const Color rideAttendeeScanResultOwnerChoiceRequiredBackgroundColor =
      Colors.red;
  static const Color rideAttendeeScanResultOwnerChoiceRequiredFontColor =
      Colors.white;
  static final Color androidManualSelectionSwitchActiveTrackColor =
      Colors.lightBlue.shade200;

  static const Color androidManualSelectionSaveButtonPrimaryColor =
      Color(0xFF1666a5);

  static const rideAttendeeScanResultMultipleOwnersLabelStyle = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 12,
    color: rideAttendeeScanResultMultipleOwnerColor,
  );

  static const rideAttendeeScanResultFirstNameTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
  );
  static const rideAttendeeMultipleOwnersListTooltipStyle = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 12,
    color: Colors.grey,
  );

  static const Color deleteItemButtonTextColor = Colors.red;

  static final importMembersHeaderExampleTextStyle = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
    color: Colors.grey.shade600,
  );

  static const importWarningTextStyle = TextStyle(color: Colors.red);

  static const Color importMembersDoneIconColor = Colors.green;

  static const appVersionTextStyle = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 12,
  );

  static const Color rideListItemEvenMonthColor = Colors.blue;

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    return CupertinoThemeData(
      primaryColor: primaryColor,
      primaryContrastingColor: secondaryColor,
    );
  }
}
