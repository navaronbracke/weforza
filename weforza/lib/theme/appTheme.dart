import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///This class provides the application [ThemeData].
abstract class ApplicationTheme {

  /// Primary / Secondary Theme colors.
  /// The primary color is defined as a [MaterialColor].
  static final MaterialColor primaryColor = Colors.blue;
  static final Color secondaryColor = Colors.blue.shade300;

  //Ride Calendar Item Styling for an item that is now or in the future, which has no ride.
  static final Color rideCalendarFutureDayNoRideFontColor = Colors.black;

  // Ride Calendar Item font color, except for future days without rides.
  static final Color rideCalendarDayFontColor = Colors.white;

  static final Color rideCalendarFutureDayWithRideBackgroundColor = Colors.blue.shade700;
  static final Color rideCalendarSelectedDayBackgroundColor = Colors.blue.shade200;
  static final Color rideCalendarPastDayWithoutRideBackgroundColor = Colors.grey.shade400;
  static final Color rideCalendarPastDayWithRideBackgroundColor = Colors.grey.shade700;

  //Ride Calendar Header Font Color
  static final Color rideCalendarHeaderColor = Colors.black;

  ///Colors for an arrow which dictates there is another choice before/ahead of the current item.
  ///Example: < "Choice" >
  ///
  ///The idle color is shown when the button is not pressed.
  ///The onPressed Color is shown otherwise.
  static final Color choiceArrowIdleColor = Colors.black;
  static final Color choiceArrowOnPressedColor = Colors.black45;

  ///The profile image placeholder's icon color.
  static const Color profileImagePlaceholderIconColor = Colors.white;
  ///The profile image placeholder icon's background color.
  static final Color profileImagePlaceholderIconBackgroundColor = Colors.blue.shade700;

  static const TextStyle personInitialsTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.white,
  );

  ///The background color for an unselected ride attendee.
  static final Color rideAttendeeUnSelectedBackgroundColor = Colors.transparent;
  ///The background color for a selected ride attendee.
  static final Color rideAttendeeSelectedBackgroundColor = Colors.blue.shade700;

  //MemberList Item First Name Text Style
  static final TextStyle memberListItemFirstNameTextStyle = TextStyle(fontSize: 18,fontWeight: FontWeight.w500);

  //MemberList Item Last Name Text Style
  static final TextStyle memberListItemLastNameTextStyle = TextStyle(fontSize: 14);

  //Cupertino Form Input Error Text Style
  static final TextStyle iosFormErrorStyle = TextStyle(fontSize: 14, color: CupertinoColors.destructiveRed);

  // Cupertino Button TextStyle
  static final TextStyle iosButtonTextStyle = TextStyle(color: primaryColor);

  static final TextStyle androidRideAttendeeListCounterTextStyle = TextStyle(fontSize: 14.0, color: Colors.white);

  static final Color deviceIconColor = Colors.blue;
  static final Color deviceTypePickerDotColor = Colors.blue.shade100;
  static final Color deviceTypePickerCurrentDotColor = Colors.blue;
  ///The member devices list header + button color for android.
  static final Color memberDevicesListHeaderAddDeviceButtonColor = Colors.blue;
  ///The member devices list header + button colors for IOS.
  static final Color memberDevicesListHeaderAddDeviceButtonIdleColor = Colors.blue;
  static final Color memberDevicesListHeaderAddDeviceButtonPressedColor = Colors.blue.shade100;
  static final TextStyle memberDevicesListHeaderTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  ///The member device item edit button color for android.
  static final Color memberDevicesListEditDeviceColor = Colors.blue.shade300;
  ///The member device item edit button colors for IOS.
  static final Color memberDevicesListEditDeviceIdleColor = Colors.blue.shade300;
  static final Color memberDevicesListEditDevicePressedColor = Colors.blue.shade100;

  ///This color is used for Icons in lists that show some information when there is nothing to show.
  static final Color listInformationalIconColor = primaryColor;

  static final TextStyle settingsOptionHeaderStyle = TextStyle(fontSize: 14);
  static final Color settingsScanSliderThumbColor = Colors.blue.shade300;
  static final TextStyle settingsResetRideCalendarDescriptionTextStyle = TextStyle(fontSize: 12, fontStyle: FontStyle.italic);

  static final Color androidRideAttendeeScanProcessCurrentStepColor = Colors.lightGreen.shade200;
  static final Color androidRideAttendeeScanProcessOtherStepColor = Colors.white;
  static final Color androidRideAttendeeScanProcessArrowColor = Colors.lightBlue.shade200;
  static final Color iosRideAttendeeScanProcessCurrentStepColor = CupertinoColors.activeGreen;
  static final Color iosRideAttendeeScanProcessOtherStepColor = CupertinoColors.inactiveGray;
  static final Color iosRideAttendeeScanProcessArrowColor = CupertinoColors.activeBlue;
  static final Color androidRideAttendeeScanProgressbarColor = Color.fromARGB(255,98,204,98);
  static final Color androidRideAttendeeScanProgressbarBackgroundColor = Color.fromARGB(120,98,204,98);
  
  static final Color iosRideAttendeeScanProgressbarColor = CupertinoColors.activeGreen;
  static final Color iosRideAttendeeScanProgressbarBackgroundColor = CupertinoColors.activeGreen.withOpacity(0.4);

  static final Color rideAttendeeScanResultSingleOwnerColor = Colors.blue;
  static final Color rideAttendeeScanResultMultipleOwnerColor = Colors.orange;
  static final Color rideAttendeeScanResultOwnerChoiceRequiredBackgroundColor = Colors.red;
  static final Color rideAttendeeScanResultOwnerChoiceRequiredFontColor = Colors.white;
  static final Color androidManualSelectionSwitchActiveTrackColor = Colors.lightBlue.shade200;

  static final Color androidManualSelectionSaveButtonPrimaryColor = Color(0xFF1666a5);

  static final TextStyle rideAttendeeScanResultMultipleOwnersLabelStyle = TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 12,
      color: rideAttendeeScanResultMultipleOwnerColor,
  );

  static final TextStyle rideAttendeeScanResultFirstNameTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0);
  static final TextStyle rideAttendeeMultipleOwnersListTooltipStyle = TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey);

  static final Color deleteItemButtonTextColor = Colors.red;

  static final TextStyle importMembersHeaderExampleTextStyle = TextStyle(
      fontSize: 12,fontStyle: FontStyle.italic, color: Colors.grey.shade600
  );

  static final TextStyle importWarningTextStyle = TextStyle(color: Colors.red);

  static final Color importMembersDoneIconColor = Colors.green;

  static final TextStyle appVersionTextStyle = TextStyle(fontStyle: FontStyle.italic, fontSize: 12);

  static final Color rideListItemEvenMonthColor = Colors.blue;

  ///Provide the Android theme.
  static ThemeData androidTheme(){
     return ThemeData(
       primarySwatch: primaryColor,
       accentColor: secondaryColor,
       splashColor: secondaryColor.withAlpha(150),
       // We need dark here, so the status bar gets a white text color.
       appBarTheme: AppBarTheme(brightness: Brightness.dark),
       // We set button styles explicitly here.
       // This makes our buttons work with the new themes for buttons.
       textButtonTheme: TextButtonThemeData(
         style: TextButton.styleFrom(
           primary: primaryColor,
           minimumSize: Size(88, 36),
           padding: EdgeInsets.symmetric(horizontal: 16.0),
           shape: const RoundedRectangleBorder(
             borderRadius: BorderRadius.all(Radius.circular(2.0)),
           ),
         )
       ),
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
           onPrimary: Colors.white,
           primary: primaryColor,
           minimumSize: Size(88, 36),
           padding: EdgeInsets.symmetric(horizontal: 16),
           shape: const RoundedRectangleBorder(
             borderRadius: BorderRadius.all(Radius.circular(2)),
           ),
         )
       )
     );
  }

  ///Provide the IOS theme.
  static CupertinoThemeData iosTheme(){
    return CupertinoThemeData(
      primaryColor: primaryColor,
      primaryContrastingColor: secondaryColor
    );
  }
}