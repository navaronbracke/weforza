import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class GenericScanErrorWidget extends StatelessWidget {
  const GenericScanErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.only(top: 5, bottom: 20),
          child: Text(S.of(context).GenericError),
        ),
        _buildGoBackButton(context)
      ],
    );
  }

  Widget _buildGoBackButton(BuildContext context) {
    return PlatformAwareWidget(
      android: () => ElevatedButton(
        child: Text(S.of(context).RideAttendeeScanningGoBackToDetailPage),
        onPressed: () => Navigator.of(context).pop(),
      ),
      ios: () => CupertinoButton.filled(
        child: Text(
          S.of(context).RideAttendeeScanningGoBackToDetailPage,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
