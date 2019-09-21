import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import 'package:weforza/generated/i18n.dart';

///This [Widget] represents the app landing page.
class HomePage extends StatelessWidget implements PlatformAwareWidget {
  ///Constructor
  ///
  ///Uses [appTitle] as title in the AppBar and middle in the navigation bar.
  HomePage(this._appTitle);

  final String _appTitle;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(S.of(context).EventCatalog,style: TextStyle(color: Colors.white)),
              onPressed: (){
                //Navigate to the events screen with the navigator
              },
            ),
            Flexible(
              child: FractionallySizedBox(heightFactor: 0.1),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(S.of(context).PersonCatalog,style: TextStyle(color: Colors.white)),
              onPressed: (){
                //Navigate to the persons screen with the navigator
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_appTitle),
      ),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoButton.filled(
                child: Text(S.of(context).EventCatalog,style: TextStyle(color: Colors.white)),
                onPressed: (){
                  //Navigate to the events screen with the navigator
                },
                pressedOpacity: 0.7,
              ),
              Flexible(
                child: FractionallySizedBox(heightFactor: 0.1),
              ),
              CupertinoButton.filled(
                child: Text(S.of(context).PersonCatalog,style: TextStyle(color: Colors.white)),
                onPressed: (){
                  //Navigate to the persons screen with the navigator
                },
                pressedOpacity: 0.7,
              )
            ],
          ),
      ),
    );
  }

}