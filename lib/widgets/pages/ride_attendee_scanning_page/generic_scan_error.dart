import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class _GenericScanErrorBase extends StatelessWidget {
  const _GenericScanErrorBase({
    this.errorMessage,
    required this.icon,
    required this.primaryButton,
    this.secondaryButton,
  });

  /// The error message to display.
  ///
  /// If this is null, [S.GenericError] is used.
  final String? errorMessage;

  /// The icon that is shown above the [errorMessage].
  final Widget icon;

  /// The button for the primary action.
  final Widget primaryButton;

  /// The button for the secondary action.
  final Widget? secondaryButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconTheme(
          data: IconThemeData(
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          child: icon,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
            child: Text(
              errorMessage ?? S.of(context).GenericError,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.center,
          overflowAlignment: OverflowBarAlignment.center,
          overflowDirection: VerticalDirection.up,
          overflowSpacing: 16,
          spacing: 8,
          children: [
            if (secondaryButton != null) secondaryButton!,
            primaryButton,
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
      errorMessage: translator.ScanAbortedBluetoothDisabled,
      icon: const PlatformAwareIcon(
        androidIcon: Icons.bluetooth_disabled,
        iosIcon: Icons.bluetooth_disabled,
      ),
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
      icon: const PlatformAwareIcon(
        androidIcon: Icons.warning,
        iosIcon: CupertinoIcons.exclamationmark_triangle_fill,
      ),
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
      errorMessage: translator.ScanAbortedPermissionDenied,
      icon: const PlatformAwareIcon(
        androidIcon: Icons.warning,
        iosIcon: CupertinoIcons.exclamationmark_triangle_fill,
      ),
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
