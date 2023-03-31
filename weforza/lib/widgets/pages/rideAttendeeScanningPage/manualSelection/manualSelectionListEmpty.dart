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
        Icon(
          Icons.people,
          color: ApplicationTheme.listInformationalIconColor,
          size: MediaQuery.of(context).size.shortestSide * .1,
        ),
        SizedBox(height: 5),
        Text(S.of(context).RideAttendeeScanningManualSelectionEmptyList),
        SizedBox(height: 20),
        PlatformAwareWidget(
          android: () => FlatButton(
            child: Text(
              S.of(context).GoBack,
              style: TextStyle(color: ApplicationTheme.primaryColor),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ios: () => CupertinoButton(
            child: Text(
              S.of(context).GoBack,
              style: TextStyle(color: ApplicationTheme.primaryColor),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
