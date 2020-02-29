import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );


  Widget _buildAndroidWidget(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).SettingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            //TODO
          ],
        ),
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).SettingsTitle),
        transitionBetweenRoutes: false,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            //TODO
          ],
        ),
      ),
    );
  }
}


