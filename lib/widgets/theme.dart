import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class defines the application theme.
abstract class AppTheme {
  /// The [ThemeData] for the [MaterialApp].
  static final androidTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    chipTheme: ChipThemeData(
      checkmarkColor: Colors.white,
      selectedColor: colorScheme.primary,
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      side: BorderSide(color: colorScheme.primary),
    ),
    extensions: <ThemeExtension>[
      DestructiveButtons(errorColor: colorScheme.error),
    ],
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
  );

  /// The color scheme for the MaterialApp.
  static final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);

  /// The [CupertinoThemeData] for the [CupertinoApp].
  static const iosTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
  );

  /// The theme for the bottom bar on the manual selection.
  static const manualSelectionBottomBar = ManualSelectionBottomBarTheme();

  /// The member list item theme.
  static const memberListItem = MemberListItemTheme();

  /// The ride calendar theme.
  static const rideCalendar = RideCalendarTheme();

  /// The theme for the scan stepper.
  static const scanStepper = ScanStepperThemes();
}

/// This class represents the theme for the bottom bar
/// on the manual ride attendee selection page.
///
/// This theme is only used on Android, as iOS uses the system defaults to
/// style its widgets.
class ManualSelectionBottomBarTheme {
  const ManualSelectionBottomBarTheme();

  /// The primary color for the save button.
  final Color saveButtonColor = const Color(0xFF1666a5);

  /// The active track color for the filter switch.
  final Color switchActiveTrackColor = const Color(0xFF81D4FA);
}

/// This class defines the theme for member list items.
class MemberListItemTheme {
  const MemberListItemTheme();

  /// The text style for the first name.
  final TextStyle firstNameStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  /// The text style for the last name.
  final TextStyle lastNameStyle = const TextStyle(fontSize: 14);
}

/// This class represents the theme for the ride calendar date picker.
class RideCalendarTheme {
  const RideCalendarTheme();

  /// The color for a planned ride that is in the future.
  final Color futureRide = const Color(0xFF1976D2);

  /// The color for a day that is in the past, which had no ride scheduled.
  final Color pastDay = const Color(0xFFBDBDBD);

  /// The color for a day that is in the past, which had a ride scheduled.
  final Color pastRide = const Color(0xFF616161);

  /// The text style for a day that has a ride scheduled,
  /// regardless if this day is in the past, in the future
  /// or in the current selection of days.
  final TextStyle scheduledDayStyle = const TextStyle(color: Colors.white);

  /// The color for a day that is currently selected.
  final Color selectedDay = const Color(0xFF90CAF9);
}

/// This class represents the data for a [ScanStepperTheme] sub theme.
class ScanStepperTheme {
  const ScanStepperTheme({
    required this.active,
    required this.arrow,
    required this.inactive,
  });

  /// The color for the active step.
  final Color active;

  /// The icon for the arrow.
  final Icon arrow;

  /// The color for inactive steps.
  final Color inactive;
}

/// This class represents the theme for a scan stepper.
class ScanStepperThemes {
  const ScanStepperThemes();

  /// The theme for the Android stepper.
  final android = const ScanStepperTheme(
    active: Color(0xFFC5E1A5),
    arrow: Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF81D4FA)),
    inactive: Colors.white,
  );

  /// The theme for the iOS stepper.
  final ios = const ScanStepperTheme(
    active: CupertinoColors.activeGreen,
    arrow: Icon(
      CupertinoIcons.chevron_forward,
      color: CupertinoColors.activeBlue,
    ),
    inactive: CupertinoColors.inactiveGray,
  );
}

/// This class defines a theme extension for destructive Material buttons.
@immutable
class DestructiveButtons extends ThemeExtension<DestructiveButtons> {
  DestructiveButtons({
    this.errorColor,
  })  : elevatedButtonStyle = ElevatedButton.styleFrom(
          backgroundColor: errorColor,
        ),
        textButtonStyle = TextButton.styleFrom(foregroundColor: errorColor);

  /// The style for destructive [ElevatedButton]s.
  final ButtonStyle elevatedButtonStyle;

  /// The color that is used to create the [ButtonStyle]s.
  final Color? errorColor;

  /// The style for destructive [TextButton]s.
  final ButtonStyle textButtonStyle;

  @override
  DestructiveButtons copyWith({Color? errorColor}) {
    return DestructiveButtons(errorColor: errorColor);
  }

  @override
  ThemeExtension<DestructiveButtons> lerp(
    ThemeExtension<DestructiveButtons>? other,
    double t,
  ) {
    if (other is! DestructiveButtons) {
      return this;
    }

    return DestructiveButtons(
      errorColor: Color.lerp(errorColor, other.errorColor, t),
    );
  }
}
