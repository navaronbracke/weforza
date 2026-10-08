import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/native_service/app_settings_delegate.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a scan error that indicates that Bluetooth is disabled.
/// It provides a button to open the Bluetooth settings and a button to retry the scan.
class BluetoothDisabledError extends StatelessWidget {
  const BluetoothDisabledError({required this.onRetry, super.key});

  static const _appSettingsDelegate = AppSettingsDelegate();

  final void Function() onRetry;

  Future<void> _openBluetoothSettings() async {
    await _appSettingsDelegate.openBluetoothSettings();
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return GenericErrorWithPrimaryAndSecondaryAction(
      errorMessage: translator.scanAbortedBluetoothDisabled,
      icon: const PlatformAwareIcon(androidIcon: Icons.bluetooth_disabled, iosIcon: Icons.bluetooth_disabled),
      primaryButton: PlatformAwareWidget(
        android: (_) {
          return ElevatedButton(onPressed: _openBluetoothSettings, child: Text(translator.goToSettings));
        },
        ios: (_) {
          return CupertinoButton.filled(
            onPressed: _openBluetoothSettings,
            child: Text(translator.goToSettings, style: const TextStyle(color: CupertinoColors.white)),
          );
        },
      ),
      secondaryButton: PlatformAwareWidget(
        android: (_) => TextButton(onPressed: onRetry, child: Text(translator.retryScan)),
        ios: (_) => CupertinoButton(onPressed: onRetry, child: Text(translator.retryScan)),
      ),
    );
  }
}

/// This widget represents a generic scan error that only provides a back button.
class GenericScanError extends StatelessWidget {
  const GenericScanError({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return GenericErrorWithPrimaryAndSecondaryAction(
      icon: const PlatformAwareIcon(androidIcon: Icons.warning, iosIcon: CupertinoIcons.exclamationmark_triangle_fill),
      primaryButton: PlatformAwareWidget(
        android: (context) {
          return ElevatedButton(
            child: Text(translator.goBackToDetailPage),
            onPressed: () => Navigator.of(context).pop(),
          );
        },
        ios: (context) {
          return CupertinoButton.filled(
            child: Text(translator.goBackToDetailPage, style: const TextStyle(color: CupertinoColors.white)),
            onPressed: () => Navigator.of(context).pop(),
          );
        },
      ),
    );
  }
}

/// This widget represents a scan error
/// that indicates that not all the required permissions were granted.
/// It provides a button to open the application settings and a back button.
class PermissionDeniedError extends StatelessWidget {
  const PermissionDeniedError({super.key});

  static const _appSettingsDelegate = AppSettingsDelegate();

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    String errorMessage;

    // Android requires both Bluetooth and Location permissions to show scan results.
    // Without the location permission, the scan cannot find devices.
    //
    // On other platforms (i.e. iOS) the location permission is not required.
    if (Platform.isAndroid) {
      errorMessage = translator.scanAbortedBluetoothAndLocationPermissionDenied;
    } else {
      errorMessage = translator.scanAbortedBluetoothPermissionDenied;
    }

    return GenericErrorWithPrimaryAndSecondaryAction(
      errorMessage: errorMessage,
      icon: const PlatformAwareIcon(androidIcon: Icons.warning, iosIcon: CupertinoIcons.exclamationmark_triangle_fill),
      primaryButton: PlatformAwareWidget(
        android: (_) {
          return ElevatedButton(onPressed: _appSettingsDelegate.openAppSettings, child: Text(translator.goToSettings));
        },
        ios: (_) {
          return CupertinoButton.filled(
            onPressed: _appSettingsDelegate.openAppSettings,
            child: Text(translator.goToSettings, style: const TextStyle(color: CupertinoColors.white)),
          );
        },
      ),
      secondaryButton: PlatformAwareWidget(
        android: (context) {
          return TextButton(child: Text(translator.goBackToDetailPage), onPressed: () => Navigator.of(context).pop());
        },
        ios: (context) {
          return CupertinoButton(
            child: Text(translator.goBackToDetailPage),
            onPressed: () => Navigator.of(context).pop(),
          );
        },
      ),
    );
  }
}
