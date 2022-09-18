import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class provides the application [ThemeData].
abstract class ApplicationTheme {
  /// Primary / Secondary Theme colors.
  /// The primary color is defined as a [MaterialColor].
  static const MaterialColor primaryColor = Colors.blue;

  /// The Android theme.
  static ThemeData androidTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: primaryColor,
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
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
      colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor),
    );
  }

  /// The iOS theme.
  static CupertinoThemeData iosTheme() {
    // TODO: use active blue
    return const CupertinoThemeData(primaryColor: primaryColor);
  }
}
