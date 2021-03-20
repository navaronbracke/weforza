import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class BluetoothDisabledWidget extends StatelessWidget {
  BluetoothDisabledWidget({
    required this.onGoToSettings,
    required this.onRetryScan,
  });

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
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Text(S.of(context).RideAttendeeScanningBluetoothDisabled),
      ),
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
        ElevatedButton(
          child: Text(S.of(context).RideAttendeeScanningGoToSettings),
          onPressed: onGoToSettings,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextButton(
            child: Text(S.of(context).RideAttendeeScanningRetryScan),
            onPressed: onRetryScan,
          ),
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
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CupertinoButton(
            child: Text(
              S.of(context).RideAttendeeScanningRetryScan,
              style: TextStyle(color: ApplicationTheme.primaryColor),
            ),
            onPressed: onRetryScan,
          ),
        ),
      ],
    );
  }
}
