import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class BluetoothDisabledWidget extends StatelessWidget {
  const BluetoothDisabledWidget({
    Key? key,
    required this.onGoToSettings,
    required this.onRetryScan,
  }) : super(key: key);

  final VoidCallback onGoToSettings;
  final VoidCallback onRetryScan;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.bluetooth_disabled,
          color: ApplicationTheme.listInformationalIconColor,
          size: MediaQuery.of(context).size.shortestSide * .1,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: Text(translator.ScanAbortedBluetoothDisabled),
        ),
        PlatformAwareWidget(
          android: () => _buildAndroidButtons(translator),
          ios: () => _buildIosButtons(translator),
        )
      ],
    );
  }

  Widget _buildAndroidButtons(S translator) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: [
        ElevatedButton(
          onPressed: onGoToSettings,
          child: Text(translator.GoToSettings),
        ),
        TextButton(
          onPressed: onRetryScan,
          child: Text(translator.RetryScan),
        ),
      ],
    );
  }

  Widget _buildIosButtons(S translator) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: [
        CupertinoButton.filled(
          onPressed: onGoToSettings,
          child: Text(
            translator.GoToSettings,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        CupertinoButton(
          onPressed: onRetryScan,
          child: Text(
            translator.RetryScan,
            style: const TextStyle(color: ApplicationTheme.primaryColor),
          ),
        ),
      ],
    );
  }
}
