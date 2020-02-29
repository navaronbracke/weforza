import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class LoadingSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).SettingsTitle),
      ),
      body: _buildBody(context),
    ),
    ios: () => CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).SettingsTitle),
        transitionBetweenRoutes: false,
      ),
      child: _buildBody(context),
    ),
  );

  Widget _buildBody(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PlatformAwareLoadingIndicator(),
          SizedBox(height: 10),
          Text(S.of(context).SettingsLoading),
        ],
      ),
    );
  }
}
