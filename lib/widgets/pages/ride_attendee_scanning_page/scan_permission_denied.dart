import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ScanPermissionDenied extends StatelessWidget {
  const ScanPermissionDenied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PlatformAwareWidget(
          android: () => Icon(
            Icons.warning,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          ios: () => Icon(
            CupertinoIcons.exclamationmark_triangle_fill,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
          child: Center(
            child: Text(translator.ScanAbortedPermissionDenied, softWrap: true),
          ),
        ),
        PlatformAwareWidget(
          android: () => _buildAndroidButtons(context),
          ios: () => _buildIosButtons(context),
        )
      ],
    );
  }

  Widget _buildAndroidButtons(BuildContext context) {
    final translator = S.of(context);

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: [
        ElevatedButton(
          child: Text(translator.GoToSettings),
          onPressed: () => openAppSettings(),
        ),
        TextButton(
          child: Text(translator.GoBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildIosButtons(BuildContext context) {
    final translator = S.of(context);

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: <Widget>[
        CupertinoButton.filled(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          child: Text(
            translator.GoToSettings,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () => openAppSettings(),
        ),
        CupertinoButton(
          child: Text(
            translator.GoBack,
            style: const TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
