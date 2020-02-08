import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentError extends StatelessWidget {
  RideAttendeeAssignmentError(this.title): assert(title != null);

  final String title;

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
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


  Widget _buildIosWidget(BuildContext context) {
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
