import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///This class provides the application [ThemeData].
abstract class ApplicationTheme {

  ///Android Theme colors.
  static final Color _androidPrimaryColor = Colors.blue;
  static final Color _androidAccentColor = Colors.blue.shade300;

  ///Cupertino Theme colors.
  static final Color _iosPrimaryColor = Colors.blue;
  static final Color _iosAccentColor = Colors.blue.shade300;

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

  //RideList Item Background Color when selected
  static final Color rideListItemSelectedColor = Colors.lightGreen;
  //RideList Item Background Color when not selected
  static final Color rideListItemUnselectedColor = Colors.white;

  //RideList Item Font Color when selected
  static final Color rideListItemSelectedFontColor = Colors.white;

  //RideList Item Font Color when not selected
  static final Color rideListItemUnselectedFontColor = Colors.black;

  //RideList Item Splash Color(Used in Material Widget)
  static final Color rideListItemSplashColor = Colors.green;

  //MemberList Item First Name Text Style
  static final TextStyle memberListItemFirstNameTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w400);

  //MemberList Item Last Name Text Style
  static final TextStyle memberListItemLastNameTextStyle = TextStyle(fontSize: 12);

  //Cupertino Form Input Error Text Style
  static final TextStyle iosFormErrorStyle = TextStyle(fontSize: 14,color: CupertinoColors.destructiveRed);

  ///Provide the Android theme.
  static ThemeData androidTheme(){
     return ThemeData(
       primaryColor: _androidPrimaryColor,
       accentColor: _androidAccentColor,
       splashColor: _androidAccentColor.withAlpha(150)
     );
  }

  ///Provide the IOS theme.
  static CupertinoThemeData iosTheme(){
    return CupertinoThemeData(
      primaryColor: _iosPrimaryColor,
      primaryContrastingColor: _iosAccentColor
    );
  }
}