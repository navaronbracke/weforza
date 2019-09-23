import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/personListPage.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import 'package:weforza/generated/i18n.dart';

///This [Widget] represents the app landing page.
class HomePage extends StatelessWidget implements PlatformAwareWidget {

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AppName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(S.of(context).EventCatalog,style: TextStyle(color: Colors.white)),
              onPressed: (){
                //TODO Navigate to the events screen with the navigator
              },
            ),
            Flexible(
              child: FractionallySizedBox(heightFactor: 0.1),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(S.of(context).PersonCatalog,style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonListPage()),
                );
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
        middle: Text(S.of(context).AppName),
      ),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoButton.filled(
                child: Text(S.of(context).EventCatalog,style: TextStyle(color: Colors.white)),
                onPressed: (){
                  //TODO Navigate to the events screen with the navigator
                },
                pressedOpacity: 0.7,
              ),
              Flexible(
                child: FractionallySizedBox(heightFactor: 0.1),
              ),
              CupertinoButton.filled(
                child: Text(S.of(context).PersonCatalog,style: TextStyle(color: Colors.white)),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonListPage()),
                  );
                },
                pressedOpacity: 0.7,
              )
            ],
          ),
      ),
    );
  }

}