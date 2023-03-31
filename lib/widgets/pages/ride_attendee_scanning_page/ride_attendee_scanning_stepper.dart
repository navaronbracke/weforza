import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the stepper at the top of the scanning page.
/// It displays the two labels of the scanning process,
/// `Scan` and `Manual`, separated by an arrow.
/// The currently applicable label is highlighted.
class RideAttendeeScanningStepper extends StatelessWidget {
  const RideAttendeeScanningStepper({super.key, required this.stream});

  /// The stream that indicates the current step in the scanning process.
  final Stream<RideAttendeeScanningState> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RideAttendeeScanningState>(
      stream: stream,
      builder: (context, snapshot) {
        // Every step before the manual selection is regarded as part of the
        // `Scan` label.
        final isScanningStep =
            snapshot.data != RideAttendeeScanningState.manualSelection;

        return PlatformAwareWidget(
          android: () => _buildAndroidWidget(context, isScanningStep),
          ios: () => _buildIosWidget(context, isScanningStep),
        );
      },
    );
  }

  Widget _buildAndroidWidget(BuildContext context, bool isScanningStep) {
    final translator = S.of(context);

    return Row(
      children: <Widget>[
        Text(
          translator.Scan.toUpperCase(),
          style: TextStyle(
            color: isScanningStep
                ? ApplicationTheme.androidScanStepperCurrentColor
                : ApplicationTheme.androidScanStepperOtherColor,
          ),
        ),
        SizedBox(
          width: 50,
          child: Center(
            child: Icon(
              Icons.arrow_forward_ios,
              color: ApplicationTheme.androidScanStepperArrowColor,
            ),
          ),
        ),
        Text(
          translator.ByHand.toUpperCase(),
          style: TextStyle(
            color: isScanningStep
                ? ApplicationTheme.androidScanStepperOtherColor
                : ApplicationTheme.androidScanStepperCurrentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context, bool isScanningStep) {
    final translator = S.of(context);

    return Row(
      children: <Widget>[
        Text(
          translator.Scan.toUpperCase(),
          style: TextStyle(
            color: isScanningStep
                ? ApplicationTheme.iosScanStepperCurrentColor
                : ApplicationTheme.iosScanStepperOtherColor,
          ),
        ),
        const SizedBox(
          width: 50,
          child: Center(
            child: Icon(
              Icons.arrow_forward_ios,
              color: ApplicationTheme.iosScanStepperArrowColor,
            ),
          ),
        ),
        Text(
          translator.ByHand.toUpperCase(),
          style: TextStyle(
            color: isScanningStep
                ? ApplicationTheme.iosScanStepperOtherColor
                : ApplicationTheme.iosScanStepperCurrentColor,
          ),
        ),
      ],
    );
  }
}
