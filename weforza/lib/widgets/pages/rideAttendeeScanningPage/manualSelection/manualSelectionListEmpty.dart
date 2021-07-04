import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ManualSelectionListEmpty extends StatelessWidget {
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
          padding: const EdgeInsets.only(top: 5, bottom: 20, left: 16, right: 16),
          child: Text(
            S.of(context).RideAttendeeScanningManualSelectionEmptyList,
            textAlign: TextAlign.center,
          ),
        ),
        PlatformAwareWidget(
          android: () => ElevatedButton(
            child: Text(S.of(context).GoBack),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ios: () => CupertinoButton.filled(
            child: Text(
              S.of(context).GoBack,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
