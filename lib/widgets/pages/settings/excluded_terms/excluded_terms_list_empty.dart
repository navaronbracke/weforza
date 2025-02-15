import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the empty exluded terms list.
class ExcludedTermsListEmpty extends StatelessWidget {
  const ExcludedTermsListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final text = S.of(context).noDisallowedWords;

    return PlatformAwareWidget(
      android: (context) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: Text(text, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
        );
      },
      ios: (context) {
        final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          ),
          padding: const EdgeInsets.all(4),
          child: Text(text, style: textStyle.copyWith(fontSize: 13), textAlign: TextAlign.center),
        );
      },
    );
  }
}
