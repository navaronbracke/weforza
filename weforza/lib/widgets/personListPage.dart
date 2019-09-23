

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] will display all known people.
class PersonListPage extends StatefulWidget {
  PersonListPage();

  //TODO fetch the BLoC from DI
  @override
  _PersonListPageState createState() => _PersonListPageState();


}

class _PersonListPageState extends State<PersonListPage> implements PlatformAwareWidget
{

  //Android: app bar has add person action
  //IOS: navigation bar has add person action
  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return Scaffold(
      appBar: AppBar(

      ),
      //build body with viewmodel state
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(

      ),
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);
  }

  @override
  void dispose(){
    //TODO close the sink, need the BLoC here
    super.dispose();
  }
}