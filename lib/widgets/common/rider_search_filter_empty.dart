import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RiderSearchFilterEmpty extends StatelessWidget {
  const RiderSearchFilterEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
          child: Text(
            S.of(context).RiderSearchFilterNoResults,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
