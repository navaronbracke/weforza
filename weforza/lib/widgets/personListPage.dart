

import 'package:dependencies_flutter/dependencies_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/personListBloc.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] will display all known people.
class PersonListPage extends StatefulWidget {

  @override
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> implements PlatformAwareWidget {

  ///The BLoC for this widget.
  ///Note: This object isn't final, since we need the BuildContext to fetch it.
  ///The BLoC is private and registered as singleton, so this doesn't cause problems.
  PersonListBloc _bloc;

  //Android: app bar has add person action
  //IOS: navigation bar has add person action
  @override
  Widget buildAndroidWidget(BuildContext context) {
    _bloc = InjectorWidget.of(context).get<PersonListBloc>();
    // TODO: implement buildAndroidWidget
    return Scaffold(
      appBar: AppBar(
        title: Text("PersonList"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add,color: Colors.white),
            onPressed: (){
              //TODO: go to add person screen
            },
          )
        ],
      ),
      body: Center()
        //TODO: use future and liestview builders instead of this center widget
      //build body with viewmodel state
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    _bloc = InjectorWidget.of(context).get<PersonListBloc>();
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
    _bloc.dispose();
    super.dispose();
  }
}