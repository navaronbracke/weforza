import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class RideAttendeeAssignmentSubmitting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PlatformAwareLoadingIndicator(),
          SizedBox(height: 5),
          Text(S.of(context).RideAttendeeAssignmentSubmitting),
        ],
      ),
    );
  }
}
