import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class SettingsPageGenericError extends StatelessWidget {
  const SettingsPageGenericError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).Settings),
        ),
        body: GenericError(text: S.of(context).GenericError),
      ),
      ios: () => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Text(S.of(context).Settings),
        ),
        child: GenericError(text: S.of(context).GenericError),
      ),
    );
  }
}
