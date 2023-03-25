import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class defines the application theme.
abstract class AppTheme {
  /// The [ThemeData] for the [MaterialApp].
  static final androidTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    extensions: <ThemeExtension>[
      DestructiveButtons(errorColor: colorScheme.error),
    ],
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      indicatorColor: const Color(0xffc2e7ff),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }

          return null;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }

          return colorScheme.primary;
        }),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppTheme.colorScheme.primary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.colorScheme.primary,
        foregroundColor: Colors.white,
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

/// This class represents the theme for the ride calendar date picker.
class RideCalendarTheme {
  const RideCalendarTheme._({
    required this.futureRide,
    required this.pastDay,
    required this.pastRide,
    required this.selection,
    this.padding = const EdgeInsets.all(4),
  });

  /// Construct a [RideCalendarTheme] for the current [ThemeData.platform].
  ///
  /// The given [context] is used to look up the target platform.
  ///
  /// Returns a [RideCalendarTheme] with a palette of colors
  /// adapted to the current platform.
  factory RideCalendarTheme.fromPlatform(
    BuildContext context, {
    EdgeInsets padding = const EdgeInsets.all(4),
  }) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        final theme = Theme.of(context);

        return RideCalendarTheme._(
          futureRide: theme.primaryColor.withOpacity(0.4),
          padding: padding,
          pastDay: Colors.grey.shade400,
          pastRide: Colors.grey.shade700,
          selection: theme.colorScheme.primary,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        final primaryColor = CupertinoTheme.of(context).primaryColor;

        return RideCalendarTheme._(
          futureRide: primaryColor.withOpacity(0.4),
          padding: padding,
          selection: primaryColor,
          pastDay: const CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.systemGrey4,
            darkColor: CupertinoColors.systemGrey,
          ),
          pastRide: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.systemGrey,
            darkColor: CupertinoColors.systemGrey4.darkColor,
          ),
        );
    }
  }

  /// The color for a ride that is in the future.
  final Color futureRide;

  /// The padding around a single day item.
  ///
  /// Defaults to 4.0 on all sides.
  final EdgeInsets padding;

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
