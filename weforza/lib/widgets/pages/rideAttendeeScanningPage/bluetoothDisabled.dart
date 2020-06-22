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
    children: <Widget>[
      Icon(
        Icons.bluetooth_disabled,
        color: ApplicationTheme.listInformationalIconColor,
        size: MediaQuery.of(context).size.shortestSide * .1,
      ),
      SizedBox(height: 5),
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
        FlatButton(
          child: Text(
            S.of(context).RideAttendeeScanningGoToBluetoothSettings,
            style: TextStyle(color: ApplicationTheme.rideAttendeeScanGoToSettingsButtonColor),
          ),
          onPressed: onGoToSettings,
        ),
        SizedBox(width: 20),
        FlatButton(
          child: Text(
            S.of(context).RideAttendeeScanningRetryScan,
            style: TextStyle(color: ApplicationTheme.rideAttendeeScanRetryScanButtonColor),
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
        CupertinoButton(
          child: Text(
            S.of(context).RideAttendeeScanningGoToBluetoothSettings,
            style: TextStyle(color: ApplicationTheme.rideAttendeeScanGoToSettingsButtonColor),
          ),
          onPressed: onGoToSettings,
        ),
        SizedBox(width: 20),
        CupertinoButton(
          child: Text(
            S.of(context).RideAttendeeScanningRetryScan,
            style: TextStyle(color: ApplicationTheme.rideAttendeeScanRetryScanButtonColor),
          ),
          onPressed: onRetryScan,
        ),
      ],
    );
  }
}
