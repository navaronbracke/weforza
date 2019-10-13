import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///This class provides the application [ThemeData].
abstract class ApplicationTheme {

  ///Android Theme colors.
  static final Color _androidPrimaryColor = Color.fromARGB(255, 38, 38, 38);
  static final Color _androidAccentColor = Color.fromARGB(255, 94, 16, 16);

  ///Android Theme Ink Splash colors.
  ///Splash color for [_androidPrimaryColor].
  static final Color _androidPrimaryDerivedSplashColor = Color.fromARGB(255, 60,60,60);
  ///Splash color for the go to member details [IconButton].
  static final Color goToMemberDetailSplashColor = Color.fromARGB(255, 173, 173, 173);

  ///Cupertino Theme colors.
  static final Color _iosPrimaryColor = Color.fromARGB(255, 38, 38, 38);
  static final Color _iosAccentColor = Color.fromARGB(255, 94, 16, 16);

  static final TextStyle memberListItemFirstNameTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w400);
  static final TextStyle memberListItemLastNameTextStyle = TextStyle(fontSize: 12);


  ///Provide the Android theme.
  static ThemeData androidTheme(){
     return ThemeData(
       primaryColor: _androidPrimaryColor,
       accentColor: _androidAccentColor,
       splashColor: _androidPrimaryDerivedSplashColor
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