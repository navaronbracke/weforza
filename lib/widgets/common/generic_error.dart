import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';

/// This class represents a generic error widget.
///
/// This widget centers itself within its parent.
class GenericError extends StatelessWidget {
  const GenericError({
    super.key,
    this.androidIcon,
    this.iosIcon,
    required this.text,
  });

  final IconData? androidIcon;

  final IconData? iosIcon;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PlatformAwareIcon(
            androidIcon: androidIcon ?? Icons.warning,
            iosIcon: iosIcon ?? CupertinoIcons.exclamationmark_triangle_fill,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(text.isEmpty ? S.of(context).GenericError : text),
          )
        ],
      ),
    );
  }
}
