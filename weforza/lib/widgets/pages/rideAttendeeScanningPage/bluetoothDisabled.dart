import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class BluetoothDisabledWidget extends StatelessWidget {
  BluetoothDisabledWidget({
    @required this.onGoToSettings,
    @required this.onRetryScan,
  }): assert(onGoToSettings != null && onRetryScan != null);

  final VoidCallback onGoToSettings;
  final VoidCallback onRetryScan;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.bluetooth_disabled,
        color: ApplicationTheme.listInformationalIconColor,
        size: MediaQuery.of(context).size.shortestSide * .1,
      ),
      SizedBox(height: 10),
      Text(S.of(context).RideAttendeeScanningBluetoothDisabled),
      SizedBox(height: 20),
      PlatformAwareWidget(
        android: () => _buildAndroidButtons(context),
        ios: () => _buildIosButtons(context),
      )
    ],
  );

  Widget _buildAndroidButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: ApplicationTheme.primaryColor,
          child: Text(
            S.of(context).RideAttendeeScanningGoToSettings,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onGoToSettings,
        ),
        SizedBox(width: 20),
        FlatButton(
          child: Text(
            S.of(context).RideAttendeeScanningRetryScan,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onRetryScan,
        ),
      ],
    );
  }

  Widget _buildIosButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CupertinoButton.filled(
          padding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 24.0,
          ),
          child: Text(
            S.of(context).RideAttendeeScanningGoToSettings,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onGoToSettings,
        ),
        SizedBox(width: 20),
        CupertinoButton(
          child: Text(
            S.of(context).RideAttendeeScanningRetryScan,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onRetryScan,
        ),
      ],
    );
  }
}
