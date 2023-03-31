import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentScanningError extends StatelessWidget {
  RideAttendeeAssignmentScanningError({
    @required this.onPressed, @required this.message
  }):assert(onPressed != null && message != null);

  final String message;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          SizedBox(height: 5),
          Text(message,style: TextStyle(color: Colors.red)),
          SizedBox(height: 5),
          PlatformAwareWidget(
            android: () => FlatButton(
              child: Text(S.of(context).RideAttendeeAssignmentReturnToList),
              onPressed: onPressed,
            ),
            ios: () => CupertinoButton(
              child: Text(S.of(context).RideAttendeeAssignmentReturnToList),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
