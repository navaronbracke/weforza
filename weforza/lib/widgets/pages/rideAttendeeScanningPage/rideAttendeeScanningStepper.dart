import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This Widget represents the stepper at the top of the scanning page.
///It shows if the user is in the scanning step or the manual assignment step.
class RideAttendeeScanningStepper extends StatelessWidget {
  RideAttendeeScanningStepper({
    required this.stream,
  });

  final Stream<bool> stream;

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
    initialData: true,
    stream: stream,
    builder: (context, snapshot) => PlatformAwareWidget(
      android: () => _buildAndroidWidget(context, snapshot.data!),
      ios: () => _buildIosWidget(context, snapshot.data!),
    ),
  );

  Widget _buildAndroidWidget(BuildContext context, bool isScanningStep){
    return Row(
      children: <Widget>[
        Text(
            S.of(context).RideAttendeeScanningProcessScanLabel.toUpperCase(),
            style: TextStyle(color: isScanningStep ? ApplicationTheme.androidRideAttendeeScanProcessCurrentStepColor:
              ApplicationTheme.androidRideAttendeeScanProcessOtherStepColor
            ),
        ),
        SizedBox(
          width: 50,
          child: Center(
              child: Icon(
                  Icons.arrow_forward_ios,
                  color: ApplicationTheme.androidRideAttendeeScanProcessArrowColor
              )
          ),
        ),
        Text(
            S.of(context).RideAttendeeScanningProcessAddMembersLabel.toUpperCase(),
            style: TextStyle(color: isScanningStep ? ApplicationTheme.androidRideAttendeeScanProcessOtherStepColor:
              ApplicationTheme.androidRideAttendeeScanProcessCurrentStepColor
          ),
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context, bool isScanningStep){
    return Row(
      children: <Widget>[
        Text(
            S.of(context).RideAttendeeScanningProcessScanLabel.toUpperCase(),
            style: TextStyle(color: isScanningStep ? ApplicationTheme.iosRideAttendeeScanProcessCurrentStepColor:
            ApplicationTheme.iosRideAttendeeScanProcessOtherStepColor)
        ),
        SizedBox(
          width: 50,
          child: Center(
              child: Icon(
                  Icons.arrow_forward_ios,
                  color: ApplicationTheme.iosRideAttendeeScanProcessArrowColor
              )
          ),
        ),
        Text(
          S.of(context).RideAttendeeScanningProcessAddMembersLabel.toUpperCase(),
          style: TextStyle(color: isScanningStep ? ApplicationTheme.iosRideAttendeeScanProcessOtherStepColor:
            ApplicationTheme.iosRideAttendeeScanProcessCurrentStepColor
          ),
        ),
      ],
    );
  }
}
