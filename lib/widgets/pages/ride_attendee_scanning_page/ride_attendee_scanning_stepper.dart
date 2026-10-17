import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';

/// This widget represents the stepper at the top of the scanning page.
class RideAttendeeScanningStepper extends StatelessWidget {
  /// The default constructor.
  const RideAttendeeScanningStepper({required this.listenable, super.key});

  /// The [ValueListenable] that indicates the current step in the scanning process.
  final ValueListenable<AsyncValue<RideAttendeeScanningState>> listenable;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return ValueListenableBuilder<AsyncValue<RideAttendeeScanningState>>(
      valueListenable: listenable,
      builder: (context, state, _) {
        if (state case AsyncError(:final error)) {
          if (error is SaveScanResultsException) {
            return Text(translator.results);
          }

          if (error is StartScanException) {
            return Text(translator.scan);
          }
        }

        if (state case AsyncData(:final value)) {
          return switch (value) {
            .bluetoothDisabled ||
            .permissionDenied ||
            .requestPermissions ||
            .scanning ||
            .startingScan ||
            .stoppingScan => Text(translator.scan),
            .unresolvedOwnersSelection => Text(translator.conflicts),
            .manualSelection => Text(translator.results),
          };
        }

        // This is a fallback, but should not happen otherwise.
        return Text(translator.scan);
      },
    );
  }
}
