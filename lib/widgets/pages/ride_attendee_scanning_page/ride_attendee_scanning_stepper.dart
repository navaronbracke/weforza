import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the stepper at the top of the scanning page.
/// It displays the two labels of the scanning process,
/// `Scan` and `Manual`, separated by an arrow.
class RideAttendeeScanningStepper extends StatelessWidget {
  const RideAttendeeScanningStepper({
    required this.initialData,
    required this.stream,
    super.key,
  });

  /// The initial data for the [StreamBuilder].
  final RideAttendeeScanningState initialData;

  /// The stream that indicates the current step in the scanning process.
  final Stream<RideAttendeeScanningState> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RideAttendeeScanningState>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        // Every step before the manual selection should highlight the `Scan` label.
        final isScanStep =
            snapshot.data != RideAttendeeScanningState.manualSelection;

        final translator = S.of(context);
        final scanLabel = translator.Scan.toUpperCase();
        final manualLabel = translator.Manual.toUpperCase();

        return PlatformAwareWidget(
          android: (context) {
            final activeColor = Colors.lime.shade300;
            const inactiveColor = Colors.white;

            return Row(
              children: [
                Text(
                  scanLabel,
                  style: TextStyle(
                    color: isScanStep ? activeColor : inactiveColor,
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 48),
                Text(
                  manualLabel,
                  style: TextStyle(
                    color: isScanStep ? inactiveColor : activeColor,
                  ),
                ),
              ],
            );
          },
          ios: (context) {
            const activeColor = CupertinoColors.activeGreen;
            const inactiveColor = CupertinoColors.inactiveGray;

            return Row(
              children: [
                Text(
                  scanLabel,
                  style: TextStyle(
                    color: isScanStep ? activeColor : inactiveColor,
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_forward,
                  color: CupertinoColors.inactiveGray,
                  size: 32,
                ),
                Text(
                  manualLabel,
                  style: TextStyle(
                    color: isScanStep ? inactiveColor : activeColor,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
