import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///This class provides the application [ThemeData]
abstract class ApplicationTheme {

  static final Color _androidPrimaryColor = Color.fromARGB(255, 38, 38, 38);
  static final Color _androidAccentColor = Color.fromARGB(255, 94, 16, 16);

  static final Color _iosPrimaryColor = Color.fromARGB(255, 38, 38, 38);
  static final Color _iosAccentColor = Color.fromARGB(255, 94, 16, 16);

  ///Provide the Android theme
  static ThemeData androidTheme(){
     return ThemeData(
       primaryColor: _androidPrimaryColor,
       accentColor: _androidAccentColor
     );
  }

  ///Provide the IOS theme
  static CupertinoThemeData iosTheme(){
    //Not really sure how Cupertino will look.
    //We could decide to omit the constructor args, to apply a default theme.
    return CupertinoThemeData(
      primaryColor: _iosPrimaryColor,
      primaryContrastingColor: _iosAccentColor
    );
  }
}