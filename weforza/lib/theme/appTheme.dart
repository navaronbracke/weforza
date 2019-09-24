import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///This class provides the application [ThemeData]
abstract class ApplicationTheme {

  ///Android

  ///Android Theme Primary color
  static final Color _androidPrimaryColor = Color.fromARGB(255, 38, 38, 38);
  ///Android Theme Accent color
  static final Color _androidAccentColor = Color.fromARGB(255, 94, 16, 16);
  ///Android Material Splash Colors
  ///Splash color derived from [_androidPrimaryColor]
  static final Color _androidPrimaryDerivedSplashColor = Color.fromARGB(255, 60,60,60);
  ///Splash color for the go to person details [IconButton].
  static final Color goToPersonDetailSplashColor = Color.fromARGB(255, 173, 173, 173);


  ///IOS

  ///Cupertino Theme Primary color
  static final Color _iosPrimaryColor = Color.fromARGB(255, 38, 38, 38);
  ///Cupertino Theme Accent color
  static final Color _iosAccentColor = Color.fromARGB(255, 94, 16, 16);



  ///Provide the Android theme
  static ThemeData androidTheme(){
     return ThemeData(
       primaryColor: _androidPrimaryColor,
       accentColor: _androidAccentColor,
       splashColor: _androidPrimaryDerivedSplashColor
     );
  }

  ///Provide the IOS theme
  static CupertinoThemeData iosTheme(){
    return CupertinoThemeData(
      primaryColor: _iosPrimaryColor,
      primaryContrastingColor: _iosAccentColor
    );
  }
}