import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import '../generated/i18n.dart';

///This [Widget] represents the app landing page.
class HomePage extends StatelessWidget implements PlatformAwareWidget {

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget

    //Placeholder
    return Scaffold(
      appBar: AppBar(
        title: Text("Android HomePageWidget"),
      ),
      body: Center(),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget

    //Placeholder
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("IOS Homepage Widget"),
      ),
      child: Container(),
    );
  }

}