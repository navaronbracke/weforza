import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ScanPermissionDenied extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.of(context).RideAttendeeScanningPermissionDenied, softWrap: true),
              Text(S.of(context).RideAttendeeScanningPermissionDeniedDescription, softWrap: true),
            ],
          ),
        ),
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
          onPressed: () async => await openAppSettings(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextButton(
            child: Text(S.of(context).GoBack),
            onPressed: () => Navigator.of(context).pop(),
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
          onPressed: () async => await openAppSettings(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CupertinoButton(
            child: Text(
              S.of(context).GoBack,
              style: TextStyle(color: ApplicationTheme.primaryColor),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
