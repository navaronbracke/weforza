import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///This class provides the application [ThemeData].
abstract class ApplicationTheme {

  ///Primary/Accent Theme colors.
  static final Color _primaryColor = Colors.blue;
  static final Color _accentColor = Colors.blue.shade300;

  //Ride Calendar Item Styling for an item that is now or in the future, which has no ride.
  static final Color rideCalendarFutureDayNoRideBackgroundColor = Color.fromARGB(255, 250, 250, 250);
  static final Color rideCalendarFutureDayNoRideFontColor = Colors.black;

  //Ride Calendar Item Styling for an item that is in the future and already has a ride planned.
  static final Color rideCalendarFutureDayWithRideBackgroundColor = Colors.blue.shade700;
  static final Color rideCalendarFutureDayWithRideFontColor = Colors.white;

  //Ride Calendar Item Styling for an item that is part of the user's selection for new rides.
  static final Color rideCalendarSelectedDayBackgroundColor = Colors.blue.shade200;
  static final Color rideCalendarSelectedDayFontColor = Colors.white;

  //Ride Calendar Item Styling for an item that is in the past and doesn't have a ride.
  static final Color rideCalendarPastDayWithoutRideBackgroundColor = Colors.grey.shade400;
  static final Color rideCalendarPastDayWithoutRideFontColor = Colors.white;

  //Ride Calendar Item Styling for an item that is in the past and does have a ride.
  static final Color rideCalendarPastDayWithRideBackgroundColor = Colors.grey.shade600;
  static final Color rideCalendarPastDayWithRideFontColor = Colors.white;

  //Ride Calendar Header Font Color
  static final Color rideCalendarHeaderColor = Colors.black;

  //Ride Calendar Header Button Color when not pressed
  static final Color rideCalendarHeaderButtonIdleColor = Colors.black;

  //Ride Calendar Header Button Color when pressed
  static final Color rideCalendarHeaderButtonOnPressedColor = Colors.black45;

  ///The profile image placeholder's icon color.
  static final Color profileImagePlaceholderIconColor = Colors.white;
  ///The profile image placeholder icon's background color.
  static final Color profileImagePlaceholderIconBackgroundColor = Colors.blue.shade700;

  ///The font color for an unselected ride attendee.
  static final Color rideAttendeeUnSelectedFontColor = Colors.black;
  ///The font color for a selected ride attendee.
  static final Color rideAttendeeSelectedFontColor = Colors.white;
  ///The background color for an unselected ride attendee.
  static final Color rideAttendeeUnSelectedBackgroundColor = Colors.white;
  ///The background color for a selected ride attendee.
  static final Color rideAttendeeSelectedBackgroundColor = Colors.lightGreen;
  ///The profile image placeholder background color when the ride attendee is unselected.
  static final Color rideAttendeeUnselectedPlaceholderBackgroundColor = Colors.blue;
  ///The profile image placeholder background color when the ride attendee is selected.
  static final Color rideAttendeeSelectedPlaceholderBackgroundColor = Colors.green;

  //MemberList Item First Name Text Style
  static final TextStyle memberListItemFirstNameTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w400);

  //MemberList Item Last Name Text Style
  static final TextStyle memberListItemLastNameTextStyle = TextStyle(fontSize: 12);

  //Cupertino Form Input Error Text Style
  static final TextStyle iosFormErrorStyle = TextStyle(fontSize: 14,color: CupertinoColors.destructiveRed);

  ///Provide the Android theme.
  static ThemeData androidTheme(){
     return ThemeData(
       primaryColor: _primaryColor,
       accentColor: _accentColor,
       splashColor: _accentColor.withAlpha(150)
     );
  }

  ///Provide the IOS theme.
  static CupertinoThemeData iosTheme(){
    return CupertinoThemeData(
      primaryColor: _primaryColor,
      primaryContrastingColor: _accentColor
    );
  }
}