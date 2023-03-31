import 'package:flutter/material.dart';

/// This class represents a widget that adapts its layout
/// to the current [TargetPlatform].
///
/// This widget currently only supports [TargetPlatform.android] and [TargetPlatform.iOS].
class PlatformAwareWidget extends StatelessWidget {
  /// The default constructor.
  const PlatformAwareWidget({
    required this.android,
    required this.ios,
    super.key,
  });

  /// The builder that is invoked for [TargetPlatform.android].
  final WidgetBuilder android;

  /// The builder that is invoked for [TargetPlatform.iOS].
  final WidgetBuilder ios;

  @override
  Widget build(BuildContext context) {
    final targetPlatform = Theme.of(context).platform;

    switch (targetPlatform) {
      case TargetPlatform.android:
        return android(context);
      case TargetPlatform.iOS:
        return ios(context);
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        throw FlutterError(
          'The current target platform: $targetPlatform is unsupported.',
        );
    }
  }
}
