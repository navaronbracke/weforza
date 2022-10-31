import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents the stepper at the top of the scanning page.
/// It displays the two labels of the scanning process,
/// `Scan` and `Manual`, separated by an arrow.
/// The currently applicable label is highlighted.
class RideAttendeeScanningStepper extends StatelessWidget {
  const RideAttendeeScanningStepper({super.key, required this.stream});

  /// The stream that indicates the current step in the scanning process.
  final Stream<RideAttendeeScanningState> stream;

  Widget _buildStepper(
    BuildContext context,
    ScanStepperTheme theme,
    bool isScanningStep,
  ) {
    final translator = S.of(context);

    return Row(
      children: [
        Text(
          translator.Scan.toUpperCase(),
          style: TextStyle(
            color: isScanningStep ? theme.active : theme.inactive,
          ),
        ),
        SizedBox(width: 40, child: Center(child: theme.arrow)),
        Text(
          translator.ByHand.toUpperCase(),
          style: TextStyle(
            color: !isScanningStep ? theme.active : theme.inactive,
          ),
        ),
      ],
    );
  }

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
          android: (context) => _buildStepper(
            context,
            AppTheme.scanStepper.android,
            isScanningStep,
          ),
          ios: (context) => _buildStepper(
            context,
            AppTheme.scanStepper.ios,
            isScanningStep,
          ),
        );
      },
    );
  }
}
