import 'package:flutter/material.dart';
import '../generated/i18n.dart';

///This [StatefulWidget] represents the app landing page.
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

///This class is the [State] for [HomePage].
///It builds a [Widget] tree, which consists of an [AppBar] and a content [Widget].
class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AppName),
      ),
      body: Center(
        //TODO: add homepage widget children
      ),
    );
  }
}