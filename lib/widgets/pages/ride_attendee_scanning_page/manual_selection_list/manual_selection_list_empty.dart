import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the empty manual selection list.
class ManualSelectionListEmpty extends StatelessWidget {
  const ManualSelectionListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PlatformAwareIcon(
          androidIcon: Icons.people,
          iosIcon: CupertinoIcons.person_2_fill,
          size: MediaQuery.sizeOf(context).shortestSide * .1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Text(
            translator.manualSelectionEmpty,
            textAlign: TextAlign.center,
          ),
        ),
        PlatformAwareWidget(
          android: (context) => ElevatedButton(
            child: Text(translator.goBack),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ios: (context) => CupertinoButton.filled(
            child: Text(translator.goBack),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
