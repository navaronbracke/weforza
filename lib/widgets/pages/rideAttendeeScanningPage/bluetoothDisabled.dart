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
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: [
        ElevatedButton(
          child: Text(S.of(context).RideAttendeeScanningGoToSettings),
          onPressed: onGoToSettings,
        ),
        TextButton(
          child: Text(S.of(context).RideAttendeeScanningRetryScan),
          onPressed: onRetryScan,
        ),
      ],
    );
  }

  Widget _buildIosButtons(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: [
        CupertinoButton.filled(
          child: Text(
            S.of(context).RideAttendeeScanningGoToSettings,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: onGoToSettings,
        ),
        CupertinoButton(
          child: Text(
            S.of(context).RideAttendeeScanningRetryScan,
            style: const TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onRetryScan,
        ),
      ],
    );
  }
}
