import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the empty exluded terms list.
class ExcludedTermsListEmpty extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final text = S.of(context).noDisallowedWords;

    return PlatformAwareWidget(
      android: (context) => Padding(
        padding: const .all(4),
        child: Text(text, style: TextTheme.of(context).bodySmall, textAlign: .center),
      ),
      ios: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: const .only(bottomLeft: .circular(10), bottomRight: .circular(10)),
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        ),
        padding: const .all(4),
        child: Text(
          text,
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 13),
          textAlign: .center,
        ),
      ),
    );
  }
}
