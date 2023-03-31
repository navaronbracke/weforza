import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class NoMembersForScanWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(S.of(context).RideAttendeeScanningNoMembers),
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