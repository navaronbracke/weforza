import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/pages/personList/personListPage.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import 'package:weforza/generated/i18n.dart';

///This [Widget] represents the app landing page.
///
///It allows navigation to [PersonListPage] and Events.
class HomePage extends StatelessWidget implements PlatformAwareWidget {

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  ///Layout
  ///
  ///Navigation buttons for the events and people list in the middle.
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
            //Go to events button
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(S.of(context).HomePageEventButtonLabel,style: TextStyle(color: Colors.white)),
              onPressed: (){
                //TODO Navigate to the events screen with the navigator
              },
            ),
            Flexible(
              child: FractionallySizedBox(heightFactor: 0.1),
            ),
            //Go to people button
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(S.of(context).HomePagePeopleButtonLabel,style: TextStyle(color: Colors.white)),
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

  ///Layout
  ///
  /// - NavigationBar (app title)
  /// - Button (go to events)
  /// - Button (go to people)
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
              //Go to events button
              CupertinoButton.filled(
                child: Text(S.of(context).HomePageEventButtonLabel,style: TextStyle(color: Colors.white)),
                onPressed: (){
                  //TODO Navigate to the events screen with the navigator
                },
                pressedOpacity: 0.7,
              ),
              Flexible(
                child: FractionallySizedBox(heightFactor: 0.1),
              ),
              //Go to people button
              CupertinoButton.filled(
                child: Text(S.of(context).HomePagePeopleButtonLabel,style: TextStyle(color: Colors.white)),
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