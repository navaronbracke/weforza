import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the base for a generic scan error.
/// It presents an icon, an error message, a primary action button
/// and a secondary action button.
class _GenericScanErrorBase extends StatelessWidget {
  const _GenericScanErrorBase({
    required this.androidIcon,
    required this.errorMessage,
    required this.iosIcon,
    required this.primaryButton,
    this.secondaryButton,
  });

  /// The icon for Android.
  final IconData androidIcon;

  /// The error message to display.
  final String errorMessage;

  /// The icon for iOS.
  final IconData iosIcon;

  /// The primary button that is displayed under the [errorMessage].
  final Widget primaryButton;

  /// The secondary button that is placed next to the [primaryButton].
  final Widget? secondaryButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlatformAwareIcon(
          androidIcon: androidIcon,
          iosIcon: iosIcon,
          size: MediaQuery.of(context).size.shortestSide * .1,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: [
            primaryButton,
            if (secondaryButton != null) secondaryButton!,
          ],
        ),
      ],
    );
  }
}

/// This widget represents a scan error that indicates that bluetooth is disabled.
/// It provides a button to open the bluetooth settings and a button to retry the scan.
class BluetoothDisabledError extends StatelessWidget {
  const BluetoothDisabledError({super.key, required this.onRetry});

  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return _GenericScanErrorBase(
      androidIcon: Icons.bluetooth_disabled,
      errorMessage: translator.ScanAbortedBluetoothDisabled,
      iosIcon: Icons.bluetooth_disabled,
      primaryButton: PlatformAwareWidget(
        android: (_) => ElevatedButton(
          onPressed: () => AppSettings.openBluetoothSettings(),
          child: Text(translator.GoToSettings),
        ),
        ios: (_) => CupertinoButton.filled(
          onPressed: () => AppSettings.openBluetoothSettings(),
          child: Text(
            translator.GoToSettings,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      secondaryButton: PlatformAwareWidget(
        android: (_) => TextButton(
          onPressed: onRetry,
          child: Text(translator.RetryScan),
        ),
        ios: (_) => CupertinoButton(
          onPressed: onRetry,
          child: Text(
            translator.RetryScan,
            style: const TextStyle(color: CupertinoColors.activeBlue),
          ),
        ),
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

    return _GenericScanErrorBase(
      androidIcon: Icons.warning,
      errorMessage: translator.GenericError,
      iosIcon: CupertinoIcons.exclamationmark_triangle_fill,
      primaryButton: PlatformAwareWidget(
        android: (context) => ElevatedButton(
          child: Text(translator.GoBackToDetailPage),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ios: (context) => CupertinoButton.filled(
          child: Text(
            translator.GoBackToDetailPage,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

/// This widget represents a scan error
/// that indicates that not all the required permissions were granted.
/// It provides a button to open the application settings and a back button.
class PermissionDeniedError extends StatelessWidget {
  const PermissionDeniedError({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return _GenericScanErrorBase(
      androidIcon: Icons.warning,
      errorMessage: translator.ScanAbortedPermissionDenied,
      iosIcon: CupertinoIcons.exclamationmark_triangle_fill,
      primaryButton: PlatformAwareWidget(
        android: (_) => ElevatedButton(
          child: Text(translator.GoToSettings),
          onPressed: () => AppSettings.openAppSettings(),
        ),
        ios: (_) => CupertinoButton.filled(
          child: Text(
            translator.GoToSettings,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () => AppSettings.openAppSettings(),
        ),
      ),
      secondaryButton: PlatformAwareWidget(
        android: (context) => TextButton(
          child: Text(translator.GoBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ios: (context) => CupertinoButton(
          child: Text(
            translator.GoBack,
            style: const TextStyle(color: CupertinoColors.activeBlue),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
