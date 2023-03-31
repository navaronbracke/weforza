import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents an [Icon] that adapts itself to the current platform.
class PlatformAwareIcon extends StatelessWidget {
  const PlatformAwareIcon({
    super.key,
    this.androidColor,
    required this.androidIcon,
    this.iosColor,
    required this.iosIcon,
    this.size,
  });

  /// The color for the [androidIcon].
  ///
  /// Defaults to [ThemeData.primaryColor] if this is null.
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
      android: (context) => Icon(
        androidIcon,
        color: androidColor ?? Theme.of(context).primaryColor,
        size: size,
      ),
      ios: (context) => Icon(
        iosIcon,
        color: iosColor ?? CupertinoTheme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}
