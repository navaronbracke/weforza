import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the base for a generic scan error.
/// It presents an icon, an error message, a primary action button
/// and a secondary action button.
class _GenericScanErrorBase extends StatelessWidget {
  const _GenericScanErrorBase({
    required this.errorMessage,
    required this.iconBuilder,
    required this.primaryButton,
    this.secondaryButton,
  });

  /// The error message to display.
  final String errorMessage;

  /// The builder for the icon.
  final Widget Function(double size) iconBuilder;

  /// The primary button that is displayed under the [errorMessage].
  final Widget primaryButton;

  /// The secondary button that is placed next to the [primaryButton].
  final Widget? secondaryButton;

  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.shortestSide * .1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconBuilder(iconSize),
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
      errorMessage: translator.ScanAbortedBluetoothDisabled,
      iconBuilder: (iconSize) => Icon(
        Icons.bluetooth_disabled,
        color: ApplicationTheme.listInformationalIconColor,
        size: iconSize,
      ),
      primaryButton: PlatformAwareWidget(
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
      secondaryButton: PlatformAwareWidget(
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
      errorMessage: translator.GenericError,
      iconBuilder: (iconSize) => PlatformAwareWidget(
        android: () => Icon(
          Icons.warning,
          color: ApplicationTheme.listInformationalIconColor,
          size: iconSize,
        ),
        ios: () => Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: ApplicationTheme.listInformationalIconColor,
          size: iconSize,
        ),
      ),
      primaryButton: PlatformAwareWidget(
        android: () => ElevatedButton(
          child: Text(translator.GoBackToDetailPage),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ios: () => CupertinoButton.filled(
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
      iconBuilder: (iconSize) => PlatformAwareWidget(
        android: () => Icon(
          Icons.warning,
          color: ApplicationTheme.listInformationalIconColor,
          size: iconSize,
        ),
        ios: () => Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: ApplicationTheme.listInformationalIconColor,
          size: iconSize,
        ),
      ),
      primaryButton: PlatformAwareWidget(
        android: () => ElevatedButton(
          child: Text(translator.GoToSettings),
          onPressed: () => AppSettings.openAppSettings(),
        ),
        ios: () => CupertinoButton.filled(
          child: Text(
            translator.GoToSettings,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () => AppSettings.openAppSettings(),
        ),
      ),
      secondaryButton: PlatformAwareWidget(
        android: () => TextButton(
          child: Text(translator.GoBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ios: () => CupertinoButton(
          child: Text(
            translator.GoBack,
            style: const TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
