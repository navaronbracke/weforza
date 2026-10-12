import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';

/// This widget represents the stepper at the top of the scanning page.
class RideAttendeeScanningStepper extends StatelessWidget {
  /// The default constructor.
  const RideAttendeeScanningStepper({required this.listenable, super.key});

  /// The [ValueListenable] that indicates the current step in the scanning process.
  final ValueListenable<RideAttendeeScanningState> listenable;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return ValueListenableBuilder<RideAttendeeScanningState>(
      valueListenable: listenable,
      builder: (context, value, _) => switch (value) {
        RideAttendeeScanningState.bluetoothDisabled ||
        RideAttendeeScanningState.permissionDenied ||
        RideAttendeeScanningState.requestPermissions ||
        RideAttendeeScanningState.scanning ||
        RideAttendeeScanningState.startingScan ||
        RideAttendeeScanningState.stoppingScan => Text(translator.scan),
        RideAttendeeScanningState.unresolvedOwnersSelection => Text(translator.conflicts),
        RideAttendeeScanningState.manualSelection => Text(translator.results),
      },
    );
  }
}
