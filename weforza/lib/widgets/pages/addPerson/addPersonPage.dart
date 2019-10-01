
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

class AddPersonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPersonPageState();

}

class _AddPersonPageState extends State<AddPersonPage> implements PlatformAwareWidget {
  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddPersonTitle),
      ),
      body: Container(),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).AddPersonTitle),
      ),
      child: Container(),
    );
  }


}