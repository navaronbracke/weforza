import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weforza/model/ride_calendar_item_state.dart';

/// This class defines the application theme.
abstract class AppTheme {
  /// Get the [ThemeData] for the [MaterialApp] when the brightness is set to [brightness].
  static ThemeData androidTheme({required Brightness brightness}) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: brightness);

    Color navigationBarIndicatorColor;
    SystemUiOverlayStyle systemUiOverlayStyle;

    switch (brightness) {
      case Brightness.dark:
        navigationBarIndicatorColor = colorScheme.primaryContainer;
        systemUiOverlayStyle = SystemUiOverlayStyle.light;
        break;
      case Brightness.light:
        // The default is not as bright as the default light blue that is commonly seen in Material 3 applications.
        navigationBarIndicatorColor = const Color(0xffc2e7ff);
        systemUiOverlayStyle = SystemUiOverlayStyle.dark;
        break;
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: navigationBarIndicatorColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
          switch (brightness) {
            case Brightness.dark:
              return IconThemeData(
                size: 24,
                color: states.contains(MaterialState.selected) ? colorScheme.primary : colorScheme.onSurface,
              );
            case Brightness.light:
              return IconThemeData(size: 24, color: colorScheme.onSurface);
          }
        }),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      extensions: <ThemeExtension>[
        DestructiveButtons(colorScheme: colorScheme),
      ],
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
              return colorScheme.onPrimary;
            }

            return colorScheme.primary;
          }),
        ),
      ),
    );
  }

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
    required this.colorScheme,
  })  : elevatedButtonStyle = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
        ),
        textButtonStyle = TextButton.styleFrom(foregroundColor: colorScheme.error);

  /// The color scheme for the button styles.
  final ColorScheme colorScheme;

  /// The style for destructive [ElevatedButton]s.
  final ButtonStyle elevatedButtonStyle;

  /// The style for destructive [TextButton]s.
  final ButtonStyle textButtonStyle;

  @override
  DestructiveButtons copyWith({ColorScheme? colorScheme}) {
    return DestructiveButtons(colorScheme: colorScheme ?? this.colorScheme);
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
      colorScheme: ColorScheme.lerp(colorScheme, other.colorScheme, t),
    );
  }
}

/// This class represents the theme for a ride calendar.
@immutable
class RideCalendarTheme {
  const RideCalendarTheme({required this.textStyle, this.decoration});

  RideCalendarTheme.filled({
    required Color backgroundColor,
    required Color labelColor,
  })  : decoration = BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: backgroundColor,
        ),
        textStyle = TextStyle(fontSize: 18, color: labelColor);

  factory RideCalendarTheme.withBrightness(
    Brightness brightness, {
    required RideCalendarTheme dark,
    required RideCalendarTheme light,
  }) {
    switch (brightness) {
      case Brightness.dark:
        return dark;
      case Brightness.light:
        return light;
    }
  }

  factory RideCalendarTheme.resolve(
    BuildContext context, {
    required RideCalendarItemState? state,
  }) {
    // Defer to default text theme for future days. These also do not have a background color.
    if (state == null) {
      return const RideCalendarTheme(textStyle: TextStyle(fontSize: 18));
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        final ThemeData theme = Theme.of(context);
        final ColorScheme colorScheme = theme.colorScheme;

        switch (state) {
          case RideCalendarItemState.currentSelection:
            return RideCalendarTheme.filled(
              backgroundColor: colorScheme.primary,
              labelColor: colorScheme.onPrimary,
            );
          case RideCalendarItemState.futureRide:
            return RideCalendarTheme.withBrightness(
              theme.brightness,
              dark: RideCalendarTheme.filled(
                backgroundColor: Colors.teal.shade300,
                labelColor: Colors.black,
              ),
              light: RideCalendarTheme.filled(
                backgroundColor: Colors.lightGreen,
                labelColor: Colors.black,
              ),
            );
          case RideCalendarItemState.pastDay:
            return RideCalendarTheme.withBrightness(
              theme.brightness,
              dark: RideCalendarTheme.filled(
                backgroundColor: colorScheme.onSurfaceVariant,
                labelColor: colorScheme.surfaceVariant,
              ),
              light: RideCalendarTheme.filled(
                backgroundColor: colorScheme.surfaceVariant,
                labelColor: colorScheme.onSurfaceVariant,
              ),
            );
          case RideCalendarItemState.pastRide:
            return RideCalendarTheme.withBrightness(
              theme.brightness,
              dark: RideCalendarTheme.filled(
                backgroundColor: const Color(0xffffca9e),
                labelColor: Colors.black,
              ),
              light: RideCalendarTheme.filled(
                backgroundColor: colorScheme.onSurfaceVariant,
                labelColor: colorScheme.surfaceVariant,
              ),
            );
        }
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        final CupertinoThemeData theme = CupertinoTheme.of(context);
        final Brightness brightness = CupertinoTheme.brightnessOf(context);
        final Color primaryColor = theme.primaryColor;

        switch (state) {
          case RideCalendarItemState.currentSelection:
            return RideCalendarTheme.filled(
              backgroundColor: primaryColor,
              labelColor: Colors.white,
            );
          case RideCalendarItemState.futureRide:
            return RideCalendarTheme.withBrightness(
              brightness,
              dark: RideCalendarTheme.filled(
                backgroundColor: CupertinoColors.systemGreen.darkColor,
                labelColor: CupertinoColors.black,
              ),
              light: RideCalendarTheme.filled(
                backgroundColor: CupertinoColors.systemGreen.color,
                labelColor: CupertinoColors.white,
              ),
            );
          case RideCalendarItemState.pastDay:
            return RideCalendarTheme.withBrightness(
              brightness,
              dark: RideCalendarTheme.filled(
                backgroundColor: CupertinoColors.inactiveGray.darkColor,
                labelColor: CupertinoColors.white,
              ),
              light: RideCalendarTheme.filled(
                backgroundColor: CupertinoColors.systemGrey,
                labelColor: CupertinoColors.white,
              ),
            );
          case RideCalendarItemState.pastRide:
            return RideCalendarTheme.withBrightness(
              brightness,
              dark: RideCalendarTheme.filled(
                backgroundColor: CupertinoColors.lightBackgroundGray,
                labelColor: CupertinoColors.black,
              ),
              light: RideCalendarTheme.filled(
                backgroundColor: CupertinoColors.systemGrey4,
                labelColor: CupertinoColors.black,
              ),
            );
        }
    }
  }

  /// The decoration for a ride calendar item.
  final BoxDecoration? decoration;

  /// The text style for a ride calendar item.
  final TextStyle textStyle;
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
