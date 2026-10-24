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
      appBarTheme: AppBarTheme(systemOverlayStyle: systemUiOverlayStyle),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: navigationBarIndicatorColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          switch (brightness) {
            case Brightness.dark:
              return IconThemeData(
                size: 24,
                color: states.contains(WidgetState.selected) ? colorScheme.primary : colorScheme.onSurface,
              );
            case Brightness.light:
              return IconThemeData(size: 24, color: colorScheme.onSurface);
          }
        }),
      ),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: colorScheme.primary)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary),
      ),
      extensions: <ThemeExtension>[DestructiveButtons(colorScheme: colorScheme)],
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }

            return null;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onPrimary;
            }

            return colorScheme.primary;
          }),
        ),
      ),
    );
  }

  /// The [CupertinoThemeData] for the [CupertinoApp].
  static const iosTheme = CupertinoThemeData(primaryColor: CupertinoColors.activeBlue);

  /// The text theme for rider names.
  static const riderTextTheme = RiderTextTheme();
}

/// This class defines a theme extension for destructive Material buttons.
@immutable
class DestructiveButtons extends ThemeExtension<DestructiveButtons> {
  new({required this.colorScheme})
    : elevatedButtonStyle = ElevatedButton.styleFrom(
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
  ThemeExtension<DestructiveButtons> lerp(ThemeExtension<DestructiveButtons>? other, double t) {
    if (other is! DestructiveButtons) {
      return this;
    }

    return DestructiveButtons(colorScheme: ColorScheme.lerp(colorScheme, other.colorScheme, t));
  }
}

/// This class represents the theme for a ride calendar.
@immutable
class RideCalendarTheme {
  const new({required this.textStyle, this.decoration});

  new filled({required Color backgroundColor, required Color labelColor})
    : decoration = BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(4)), color: backgroundColor),
      textStyle = TextStyle(fontSize: 18, color: labelColor);

  factory withBrightness(Brightness brightness, {required RideCalendarTheme dark, required RideCalendarTheme light}) {
    return switch (brightness) {
      .dark => dark,
      .light => light,
    };
  }

  factory resolve(BuildContext context, {required RideCalendarItemState? state}) {
    // Defer to default text theme for future days. These also do not have a background color.
    if (state == null) {
      return const RideCalendarTheme(textStyle: TextStyle(fontSize: 18));
    }

    switch (defaultTargetPlatform) {
      case .android:
      case .fuchsia:
      case .linux:
      case .windows:
        final Brightness brightness = Theme.brightnessOf(context);
        final ColorScheme colorScheme = ColorScheme.of(context);

        return switch (state) {
          .currentSelection => .filled(backgroundColor: colorScheme.primary, labelColor: colorScheme.onPrimary),
          .futureRide => .withBrightness(
            brightness,
            dark: .filled(backgroundColor: Colors.teal.shade300, labelColor: Colors.black),
            light: .filled(backgroundColor: Colors.lightGreen, labelColor: Colors.black),
          ),
          .pastDay => .withBrightness(
            brightness,
            dark: .filled(
              backgroundColor: colorScheme.onSurfaceVariant,
              labelColor: colorScheme.surfaceContainerHighest,
            ),
            light: .filled(
              backgroundColor: colorScheme.surfaceContainerHighest,
              labelColor: colorScheme.onSurfaceVariant,
            ),
          ),
          .pastRide => .withBrightness(
            brightness,
            dark: .filled(
              backgroundColor: colorScheme.onSurface.withValues(alpha: 0.36),
              labelColor: colorScheme.onSurface,
            ),
            light: .filled(
              backgroundColor: colorScheme.onSurfaceVariant,
              labelColor: colorScheme.surfaceContainerHighest,
            ),
          ),
        };
      case .iOS:
      case .macOS:
        final Brightness brightness = CupertinoTheme.brightnessOf(context);

        return switch (state) {
          .currentSelection => .filled(
            backgroundColor: CupertinoTheme.of(context).primaryColor,
            labelColor: CupertinoColors.white,
          ),
          .futureRide => .withBrightness(
            brightness,
            dark: .filled(backgroundColor: CupertinoColors.systemGreen.darkColor, labelColor: CupertinoColors.black),
            light: .filled(backgroundColor: CupertinoColors.systemGreen.color, labelColor: CupertinoColors.white),
          ),
          .pastDay => .withBrightness(
            brightness,
            dark: .filled(backgroundColor: CupertinoColors.systemGrey3, labelColor: CupertinoColors.black),
            light: .filled(backgroundColor: CupertinoColors.systemGrey5, labelColor: CupertinoColors.black),
          ),
          .pastRide => .withBrightness(
            brightness,
            dark: .filled(backgroundColor: CupertinoColors.inactiveGray.darkColor, labelColor: CupertinoColors.white),
            light: .filled(backgroundColor: CupertinoColors.systemGrey, labelColor: CupertinoColors.white),
          ),
        };
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
  const new();

  /// The text style for rider aliases.
  final TextStyle aliasStyle = const TextStyle(fontSize: 14, fontStyle: .italic);

  /// The style for rider first names, slightly larger than [firstNameStyle].
  final TextStyle firstNameLargeStyle = const TextStyle(fontSize: 24, fontWeight: .w500);

  /// The style for rider first names.
  final TextStyle firstNameStyle = const TextStyle(fontSize: 18, fontWeight: .w500);

  /// The style for rider last names, slightly larger than [lastNameStyle].
  final TextStyle lastNameLargeStyle = const TextStyle(fontSize: 20);

  /// The style for rider last names.
  final TextStyle lastNameStyle = const TextStyle(fontSize: 14);
}
