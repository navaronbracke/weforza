import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';

/// This widget represents the footer for the excluded terms list.
class ExcludedTermsListFooter extends StatelessWidget {
  const ExcludedTermsListFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = S.of(context).disallowedWordsDescription;

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Text(
          description,
          style: TextStyle(
            fontSize: 13.0,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        );
    }
  }
}
