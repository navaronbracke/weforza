import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class EnableBluetoothDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).EnableBluetoothDialogTitle),
      content: Text(S.of(context).EnableBluetoothDialogDescription),
      actions: <Widget>[
        FlatButton(
          child: Text(S.of(context).DialogCancel),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text(S.of(context).EnableBluetoothGoToSettings),
          onPressed: () async => await AppSettings.openBluetoothSettings(),
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(S.of(context).EnableBluetoothDialogTitle),
      content: Text(S.of(context).EnableBluetoothDialogDescription),
      actions: <Widget>[
        CupertinoButton(
          child: Text(S.of(context).DialogCancel),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoButton(
          child: Text(S.of(context).EnableBluetoothGoToSettings),
          onPressed: () async => await AppSettings.openBluetoothSettings(),
        ),
      ],
    );
  }
}
