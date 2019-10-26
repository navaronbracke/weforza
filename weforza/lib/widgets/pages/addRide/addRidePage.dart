import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/custom/addRideCalendar.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a page where one or more rides can be added.
class AddRidePage extends StatefulWidget {
  @override
  _AddRidePageState createState() => _AddRidePageState();
}

///This class is the State for [AddRidePage].
class _AddRidePageState extends State<AddRidePage> implements PlatformAwareWidget, PlatformAndOrientationAwareWidget {
  @override
  Widget build(BuildContext context) =>
      PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildAndroidPortraitLayout(context),
        buildAndroidLandscapeLayout(context)
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildIOSPortraitLayout(context),
        buildIOSLandscapeLayout(context)
    );
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddRideTitle),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: AddRideCalendar()
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).AddRideInvalidDateSelection),//TODO no rides selected message + put this error in the BLoC
                SizedBox(height: 10),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(S.of(context).AddRideSubmit,softWrap: true,style:TextStyle(color: Colors.white)),
                  onPressed:  (){
                    //TODO save selection with bloc after checking valid dates + is there a selection
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildAndroidPortraitLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddRideTitle),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: AddRideCalendar(),
            ),
          ),
          Flexible(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(S.of(context).AddRideInvalidDateSelection),//TODO no rides selected message + put this error in the BLoC
                  SizedBox(height: 10),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(S.of(context).AddRideSubmit,softWrap: true,style:TextStyle(color: Colors.white)),
                    onPressed:  (){
                      //TODO save selection with bloc after checking valid dates + is there a selection
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIOSLandscapeLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).AddRideTitle),
      ),
      child: SafeArea(
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: AddRideCalendar()
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(S.of(context).AddRideInvalidDateSelection),//TODO no rides selected message + put this error in the BLoC
                  SizedBox(height: 10),
                  CupertinoButton.filled(
                      pressedOpacity: 0.5,
                      child: Text(S.of(context).AddRideSubmit,softWrap: true,style: TextStyle(color: Colors.white)), onPressed: (){
                    //TODO save selection with bloc after checking valid dates + is there a selection
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).AddRideTitle),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: AddRideCalendar(),
              ),
            ),
            Flexible(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(S.of(context).AddRideInvalidDateSelection),//TODO no rides selected message + put this error in the BLoC
                    SizedBox(height: 10),
                    CupertinoButton.filled(
                        pressedOpacity: 0.5,
                        child: Text(S.of(context).AddRideSubmit,softWrap: true,style: TextStyle(color: Colors.white)), onPressed: (){
                      //TODO save selection with bloc after checking valid dates + is there a selection
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
