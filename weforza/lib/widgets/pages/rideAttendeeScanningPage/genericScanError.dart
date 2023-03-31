import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class GenericScanErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.warning,
        color: ApplicationTheme.listInformationalIconColor,
        size: MediaQuery.of(context).size.shortestSide * .1,
      ),
      SizedBox(height: 5),
      Text(S.of(context).RideAttendeeScanningGenericError),
      SizedBox(height: 20),
      _buildGoBackButton(context)
    ],
  );

  Widget _buildGoBackButton(BuildContext context) => PlatformAwareWidget(
      android: () => FlatButton(
        child: Text(S.of(context).RideAttendeeScanningGoBack),
        onPressed: () => Navigator.of(context).pop(),
      ),
      ios:  () => CupertinoButton(
        child: Text(S.of(context).RideAttendeeScanningGoBack),
        onPressed: () => Navigator.of(context).pop(),
      )
  );
}