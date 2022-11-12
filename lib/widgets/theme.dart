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
    colorScheme: colorScheme,
  );

  /// The color scheme for the MaterialApp.
  static final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);

  /// The [CupertinoThemeData] for the [CupertinoApp].
  static const iosTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
  );

  /// The theme for the bottom bar on the manual selection.
  static const manualSelectionBottomBar = ManualSelectionBottomBarTheme();

  /// The text theme for rider names.
  static const riderTextTheme = RiderTextTheme();
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

/// This class represents the theme for the ride calendar date picker.
class RideCalendarTheme {
  const RideCalendarTheme._({
    required this.futureRide,
    required this.pastDay,
    required this.pastRide,
    required this.selection,
  });

  /// Construct a [RideCalendarTheme] for the current [ThemeData.platform].
  ///
  /// The given [context] is used to look up the target platform.
  ///
  /// Returns a [RideCalendarTheme] with a palette of colors
  /// adapted to the current platform.
  factory RideCalendarTheme.fromPlatform(BuildContext context) {
    final theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return RideCalendarTheme._(
          futureRide: theme.primaryColor.withOpacity(0.4),
          pastDay: Colors.grey.shade400,
          pastRide: Colors.grey.shade700,
          selection: theme.colorScheme.primary,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        final primaryColor = CupertinoTheme.of(context).primaryColor;

        return RideCalendarTheme._(
          futureRide: primaryColor.withOpacity(0.4),
          pastDay: CupertinoColors.systemGrey4,
          pastRide: CupertinoColors.inactiveGray,
          selection: primaryColor,
        );
    }
  }

  /// The color for a ride that is in the future.
  final Color futureRide;

  /// The color for a day in the past, which did not have a ride planned.
  final Color pastDay;

  /// The color for a ride that is in the past.
  final Color pastRide;

  /// The color for currently selected days.
  final Color selection;
}

/// This class defines the text theme for rider names.
@immutable
class RiderTextTheme {
  const RiderTextTheme();

  /// The text style for rider aliases.
  final TextStyle aliasStyle = const TextStyle(
    fontSize: 14,
    fontStyle: FontStyle.italic,
  );

  /// The style for rider first names, slightly larger than [firstNameStyle].
  final TextStyle firstNameLargeStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  /// The style for rider first names.
  final TextStyle firstNameStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  /// The style for rider last names, slightly larger than [lastNameStyle].
  final TextStyle lastNameLargeStyle = const TextStyle(fontSize: 20);

  /// The style for rider last names.
  final TextStyle lastNameStyle = const TextStyle(fontSize: 14);
}
