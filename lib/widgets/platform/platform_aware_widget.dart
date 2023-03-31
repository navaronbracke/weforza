import 'package:flutter/foundation.dart';
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android(context);
      case TargetPlatform.iOS:
        return ios(context);
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        throw UnsupportedError('The platform $defaultTargetPlatform is not supported.');
    }
  }
}
