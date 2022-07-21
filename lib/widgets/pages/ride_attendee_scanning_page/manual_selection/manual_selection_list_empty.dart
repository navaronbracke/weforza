import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ManualSelectionListEmpty extends StatelessWidget {
  const ManualSelectionListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PlatformAwareWidget(
          android: () => Icon(
            Icons.people,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          ios: () => Icon(
            CupertinoIcons.person_2_fill,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Text(
            translator.ManualSelectionEmpty,
            textAlign: TextAlign.center,
          ),
        ),
        PlatformAwareWidget(
          android: () => ElevatedButton(
            child: Text(translator.GoBack),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ios: () => CupertinoButton.filled(
            child: Text(
              translator.GoBack,
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
