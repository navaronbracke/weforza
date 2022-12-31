import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This class represents a generic error widget.
class GenericError extends StatelessWidget {
  const GenericError({
    this.actionButton,
    this.androidIcon,
    this.iosIcon,
    this.message,
    super.key,
  });

  /// The action button that is displayed below the [message].
  final Widget? actionButton;

  /// The icon that is used for [TargetPlatform.android].
  ///
  /// Defaults to [Icons.warning].
  final IconData? androidIcon;

  /// The icon that is used for [TargetPlatform.iOS].
  ///
  /// Defaults to [CupertinoIcons.exclamationmark_triangle_fill].
  final IconData? iosIcon;

  /// The message to display.
  ///
  /// Defaults to [S.GenericError].
  final String? message;

  @override
  Widget build(BuildContext context) {
    String effectiveMessage = message ?? '';

    if (effectiveMessage.isEmpty) {
      effectiveMessage = S.of(context).GenericError;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PlatformAwareIcon(
          androidIcon: androidIcon ?? Icons.warning,
          iosIcon: iosIcon ?? CupertinoIcons.exclamationmark_triangle_fill,
          size: MediaQuery.of(context).size.shortestSide * .1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(effectiveMessage),
        ),
        if (actionButton != null) actionButton!,
      ],
    );
  }
}

/// This class represents a [GenericError] with a default back button
/// as the [GenericError.actionButton].
class GenericErrorWithBackButton extends StatelessWidget {
  const GenericErrorWithBackButton({
    required this.message,
    this.androidIcon,
    this.iosIcon,
    super.key,
  });

  /// The icon that is used for [TargetPlatform.android].
  ///
  /// Defaults to [Icons.warning].
  final IconData? androidIcon;

  /// The icon that is used for [TargetPlatform.iOS].
  ///
  /// Defaults to [CupertinoIcons.exclamationmark_triangle_fill].
  final IconData? iosIcon;

  /// The message to display.
  final String message;

  @override
  Widget build(BuildContext context) {
    final goBackLabel = S.of(context).GoBack;

    return GenericError(
      actionButton: PlatformAwareWidget(
        android: (_) => TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(goBackLabel),
        ),
        ios: (_) => CupertinoButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(goBackLabel),
        ),
      ),
      androidIcon: androidIcon,
      iosIcon: iosIcon,
      message: message,
    );
  }
}
