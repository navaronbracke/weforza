import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class SettingsPageGenericError extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return PlatformAwareWidget(
      android: () => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).SettingsTitle),
        ),
        body: GenericError(text: S.of(context).GenericError),
      ),
      ios: () => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Text(S.of(context).SettingsTitle),
        ),
        child: GenericError(text: S.of(context).GenericError),
      ),
    );
  }
}
