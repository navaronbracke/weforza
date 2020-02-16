import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class RideAttendeeAssignmentScanningLoadDevices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: PlatformAwareLoadingIndicator(),
          ),
          Expanded(
            child: Text(S.of(context).RideAttendeeAssignmentLoadingDevices),
          ),
        ],
      ),
    );
  }
}
