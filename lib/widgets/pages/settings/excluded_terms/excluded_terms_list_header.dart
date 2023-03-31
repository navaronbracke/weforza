import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';

/// This widget represents the header for the excluded terms list.
class ExcludedTermsListHeader extends StatelessWidget {
  const ExcludedTermsListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = S.of(context).DisallowedWords;

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Text(title, style: theme.textTheme.titleMedium);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 13.0,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        );
    }
  }
}
