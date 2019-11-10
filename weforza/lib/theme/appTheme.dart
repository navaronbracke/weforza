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

  static final Color rideCalendarPastDayNoRideColor = Color.fromARGB(255, 134,146,156);
  static final Color rideCalendarPastDayWithRideColor = Color.fromARGB(255, 52,95,128);

  static final Color rideListItemSelectedColor = Colors.lightGreen;
  static final Color rideListItemUnselectedColor = Colors.white;
  static final Color rideListItemSelectedFontColor = Colors.white;
  static final Color rideListItemUnselectedFontColor = Colors.black;
  static final Color rideListItemSplashColor = Colors.green;

  static final TextStyle memberListItemFirstNameTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w400);
  static final TextStyle memberListItemLastNameTextStyle = TextStyle(fontSize: 12);
  static final TextStyle iosFormErrorStyle = TextStyle(fontSize: 14,color: CupertinoColors.destructiveRed);
  static final TextStyle rideCalendarDayStyle = TextStyle(fontSize: 14,color: Colors.black);
  static final TextStyle rideCalendarDayBuilderStyle = TextStyle(fontSize: 14, color: Colors.white);

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