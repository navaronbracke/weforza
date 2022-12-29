import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';

/// This class represents a generic error widget.
class GenericError extends StatelessWidget {
  const GenericError({
    this.androidIcon,
    this.iosIcon,
    this.text,
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
  ///
  /// Defaults to [S.GenericError].
  final String? text;

  @override
  Widget build(BuildContext context) {
    String effectiveMessage = text ?? '';

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
          padding: const EdgeInsets.only(top: 4),
          child: Text(effectiveMessage),
        )
      ],
    );
  }
}
