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
      PlatformAwareWidget(
        android: () => Icon(
          Icons.warning,
          color: ApplicationTheme.listInformationalIconColor,
          size: MediaQuery.of(context).size.shortestSide * .1,
        ),
        ios: () => Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: ApplicationTheme.listInformationalIconColor,
          size: MediaQuery.of(context).size.shortestSide * .1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 20),
        child: Text(S.of(context).GenericError),
      ),
      _buildGoBackButton(context)
    ],
  );

  Widget _buildGoBackButton(BuildContext context) => PlatformAwareWidget(
      android: () => ElevatedButton(
        child: Text(S.of(context).RideAttendeeScanningGoBackToDetailPage),
        onPressed: () => Navigator.of(context).pop(),
      ),
      ios:  () => CupertinoButton.filled(
        child: Text(
          S.of(context).RideAttendeeScanningGoBackToDetailPage,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => Navigator.of(context).pop(),
      )
  );
}