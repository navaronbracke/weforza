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
  /// Defaults to [S.genericError].
  final String? message;

  @override
  Widget build(BuildContext context) {
    String effectiveMessage = message ?? '';

    if (effectiveMessage.isEmpty) {
      effectiveMessage = S.of(context).genericError;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PlatformAwareIcon(
          androidIcon: androidIcon ?? Icons.warning,
          iosIcon: iosIcon ?? CupertinoIcons.exclamationmark_triangle_fill,
          size: MediaQuery.sizeOf(context).shortestSide * .1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(effectiveMessage, textAlign: TextAlign.center, softWrap: true),
        ),
        if (actionButton != null) actionButton!,
      ],
    );
  }
}

/// This class represents an error label
/// that uses the default error style for the current platform.
class GenericErrorLabel extends StatelessWidget {
  const GenericErrorLabel({
    required this.message,
    this.androidPadding = EdgeInsets.zero,
    this.iosPadding = EdgeInsets.zero,
    super.key,
  });

  /// The padding to apply to the Android layout.
  final EdgeInsetsGeometry androidPadding;

  /// The padding to apply to the iOS layout.
  final EdgeInsetsGeometry iosPadding;

  /// The message to display.
  final String message;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) {
        final child = DefaultTextStyle(
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
          ),
          child: Text(message, softWrap: true),
        );

        if (androidPadding != EdgeInsets.zero) {
          return Padding(padding: androidPadding, child: child);
        }

        return child;
      },
      ios: (_) {
        final child = DefaultTextStyle(
          style: const TextStyle(
            color: CupertinoColors.destructiveRed,
            fontWeight: FontWeight.w500,
          ),
          child: Text(message),
        );

        if (iosPadding != EdgeInsets.zero) {
          return Padding(padding: iosPadding, child: child);
        }

        return child;
      },
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
    final goBackLabel = S.of(context).goBack;

    return GenericError(
      actionButton: PlatformAwareWidget(
        android: (_) => FilledButton.tonal(
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
