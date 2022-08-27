import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class BluetoothDisabledError extends StatelessWidget {
  const BluetoothDisabledError({super.key, required this.onRetry});

  final void Function() onRetry;

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
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: [
            PlatformAwareWidget(
              android: () => ElevatedButton(
                onPressed: () => AppSettings.openBluetoothSettings(),
                child: Text(translator.GoToSettings),
              ),
              ios: () => CupertinoButton.filled(
                onPressed: () => AppSettings.openBluetoothSettings(),
                child: Text(
                  translator.GoToSettings,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            PlatformAwareWidget(
              android: () => TextButton(
                onPressed: onRetry,
                child: Text(translator.RetryScan),
              ),
              ios: () => CupertinoButton(
                onPressed: onRetry,
                child: Text(
                  translator.RetryScan,
                  style: const TextStyle(color: ApplicationTheme.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
