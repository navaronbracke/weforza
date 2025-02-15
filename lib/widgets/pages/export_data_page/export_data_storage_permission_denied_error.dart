import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the error message that is shown when the required storage permission
/// has not been granted when exporting to a file.
/// It provides a button to open the application settings and a back button.
class ExportDataStoragePermissionDeniedError extends StatelessWidget {
  const ExportDataStoragePermissionDeniedError({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return GenericErrorWithPrimaryAndSecondaryAction(
      errorMessage: translator.exportStoragePermissionDenied,
      icon: const PlatformAwareIcon(androidIcon: Icons.folder_off, iosIcon: CupertinoIcons.folder_solid),
      primaryButton: PlatformAwareWidget(
        android: (_) => ElevatedButton(onPressed: AppSettings.openAppSettings, child: Text(translator.goToSettings)),
        ios: (_) {
          return CupertinoButton.filled(
            onPressed: AppSettings.openAppSettings,
            child: Text(translator.goToSettings, style: const TextStyle(color: CupertinoColors.white)),
          );
        },
      ),
      secondaryButton: PlatformAwareWidget(
        android: (context) => TextButton(child: Text(translator.goBack), onPressed: () => Navigator.of(context).pop()),
        ios: (context) => CupertinoButton(child: Text(translator.goBack), onPressed: () => Navigator.of(context).pop()),
      ),
    );
  }
}
