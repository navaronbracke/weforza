import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class provides the application [ThemeData].
abstract class ApplicationTheme {
  /// Primary / Secondary Theme colors.
  /// The primary color is defined as a [MaterialColor].
  static const MaterialColor primaryColor = Colors.blue;

  static const Color secondaryColor = Color(0xFF64B5F6);

  // ==== Miscellaneous stuff

  static const Color deleteItemButtonTextColor = Colors.red;

  static const importWarningTextStyle = TextStyle(color: Colors.red);

  static const Color importMembersDoneIconColor = Colors.green;

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
