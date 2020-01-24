import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentError extends StatelessWidget implements PlatformAwareWidget {
  RideAttendeeAssignmentError(this.title): assert(title != null);

  final String title;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title,style: TextStyle(fontSize: 16))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.warning),
          SizedBox(height: 5),
          Text(S.of(context).RideAttendeeAssignmentError),
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(title),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.warning),
          SizedBox(height: 5),
          Text(S.of(context).RideAttendeeAssignmentError),
        ],
      ),
    );
  }
}
