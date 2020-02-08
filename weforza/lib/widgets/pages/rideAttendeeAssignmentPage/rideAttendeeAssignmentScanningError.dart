import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/generated/i18n.dart';

///This widget represents an error widget for a failed scan.
///It provides the user with a way to return to the manual assignment screen by using its [onPressed] callback.
class RideAttendeeAssignmentScanningError extends StatelessWidget {
  RideAttendeeAssignmentScanningError(this.title,this.onPressed):
        assert(title != null && onPressed != null);

  final String title;
  final VoidCallback onPressed;

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
          Text(S.of(context).RideAttendeeAssignmentScanningFailed),
          SizedBox(height: 15),
          FlatButton(child: Text(S.of(context).RideAttendeeAssignmentReturnToList),onPressed: onPressed),
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
          Text(S.of(context).RideAttendeeAssignmentScanningFailed),
          SizedBox(height: 15),
          CupertinoButton(child: Text(S.of(context).RideAttendeeAssignmentReturnToList),onPressed: onPressed),
        ],
      ),
    );
  }
}
