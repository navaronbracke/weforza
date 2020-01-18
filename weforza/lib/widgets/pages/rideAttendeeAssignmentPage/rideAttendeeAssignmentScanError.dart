
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/attendeeScanner.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentScanError extends StatelessWidget implements PlatformAwareWidget {
  RideAttendeeAssignmentScanError(this.title, this.scanner): assert(title != null && scanner != null);

  final String title;
  final AttendeeScanner scanner;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(S.of(context).RideAttendeeAssignmentScanningFailed),
            SizedBox(height: 20),
            FlatButton(child: Text(S.of(context).DialogOk),onPressed: () => scanner.stopScan())
          ],
        ),
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
      child: Center(
        child: Column(
          children: <Widget>[
            Text(S.of(context).RideAttendeeAssignmentScanningFailed),
            SizedBox(height: 20),
            CupertinoButton(child: Text(S.of(context).DialogOk),onPressed: () => scanner.stopScan())
          ],
        ),
      ),
    );
  }
}
