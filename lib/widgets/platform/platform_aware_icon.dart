import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents an [Icon] that adapts itself to the current platform.
class PlatformAwareIcon extends StatelessWidget {
  const PlatformAwareIcon({
    required this.androidIcon,
    required this.iosIcon,
    super.key,
    this.androidColor,
    this.iosColor,
    this.size,
  });

  /// The color for the [androidIcon].
  ///
  /// Defaults to [ColorScheme.primary] if this is null.
  final Color? androidColor;

  /// The icon for Android.
  final IconData androidIcon;

  /// The color for the [iosIcon].
  ///
  /// Defaults to [CupertinoThemeData.primaryColor] if this is null.
  final Color? iosColor;

  /// The icon for iOS.
  final IconData iosIcon;

  /// The size for the icon.
  final double? size;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) => Icon(androidIcon, color: androidColor ?? ColorScheme.of(context).primary, size: size),
      ios: (context) => Icon(iosIcon, color: iosColor ?? CupertinoTheme.of(context).primaryColor, size: size),
    );
  }
}
