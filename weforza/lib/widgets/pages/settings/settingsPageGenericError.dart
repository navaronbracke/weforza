import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class SettingsPageGenericError extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return PlatformAwareWidget(
      android: () => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).SettingsTitle),
        ),
        body: _buildBody(context),
      ),
      ios: () => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Text(S.of(context).SettingsTitle),
        ),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          SizedBox(height: 5),
          Text(S.of(context).GenericError)
        ],
      ),
    );
  }
}
