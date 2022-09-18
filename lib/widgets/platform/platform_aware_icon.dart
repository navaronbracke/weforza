import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents an [Icon] that adapts itself to the current platform.
class PlatformAwareIcon extends StatelessWidget {
  const PlatformAwareIcon({
    super.key,
    this.androidColor = Colors.blue,
    required this.androidIcon,
    this.iosColor = CupertinoColors.activeBlue,
    required this.iosIcon,
    this.size,
  });

  /// The color for the [androidIcon].
  ///
  /// Defaults to [Colors.blue].
  final Color androidColor;

  /// The icon for Android.
  final IconData androidIcon;

  /// The color for the [iosIcon].
  final Color iosColor;

  /// The icon for iOS.
  ///
  /// Defaults to [CupertinoColors.activeBlue].
  final IconData iosIcon;

  /// The size for the icon.
  final double? size;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => Icon(androidIcon, color: androidColor, size: size),
      ios: () => Icon(iosIcon, color: iosColor, size: size),
    );
  }
}
