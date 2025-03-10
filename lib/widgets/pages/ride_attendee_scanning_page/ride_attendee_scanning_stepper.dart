import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';

/// This widget represents the stepper at the top of the scanning page.
class RideAttendeeScanningStepper extends StatelessWidget {
  /// The default constructor.
  const RideAttendeeScanningStepper({required this.initialData, required this.stream, super.key});

  /// The initial value for the stepper.
  final RideAttendeeScanningState initialData;

  /// The stream that indicates the current step in the scanning process.
  final Stream<RideAttendeeScanningState> stream;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return StreamBuilder<RideAttendeeScanningState>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.requireData) {
          case RideAttendeeScanningState.bluetoothDisabled:
          case RideAttendeeScanningState.permissionDenied:
          case RideAttendeeScanningState.requestPermissions:
          case RideAttendeeScanningState.scanning:
          case RideAttendeeScanningState.startingScan:
          case RideAttendeeScanningState.stoppingScan:
            return Text(translator.scan);
          case RideAttendeeScanningState.unresolvedOwnersSelection:
            return Text(translator.conflicts);
          case RideAttendeeScanningState.manualSelection:
            return Text(translator.results);
        }
      },
    );
  }
}
