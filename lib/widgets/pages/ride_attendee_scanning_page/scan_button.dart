import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a button for the ride attendee scanning page.
class ScanButton extends StatelessWidget {
  const new({required this.onPressed, required this.text, super.key});

  final void Function()? onPressed;

  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PlatformAwareWidget(
        android: (_) => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: ElevatedButton(onPressed: onPressed, child: Text(text)),
        ),
        ios: (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CupertinoButton.filled(
            onPressed: onPressed,
            child: Text(text, style: const TextStyle(color: CupertinoColors.white)),
          ),
        ),
      ),
    );
  }
}

/// This widget represents a button that stops a scan.
class StopScanButton extends StatelessWidget {
  const new({required this.delegate, super.key});

  /// The delegate that manages the running scan.
  final RideAttendeeScanningDelegate delegate;

  bool _isButtonEnabled(AsyncValue<RideAttendeeScanningState> state) {
    // If the state is an error state, either the scan hasn't started,
    // it failed to stop (in which case a retry should be possible), or it has already stopped.
    if (state is! AsyncData<RideAttendeeScanningState>) {
      return true;
    }

    return switch (state.value) {
      // The following states don't happen when the scanner is on.
      .bluetoothDisabled ||
      .initializing ||
      .manualSelection ||
      .permissionDenied ||
      .requestPermissions ||
      .unresolvedOwnersSelection ||
      .startingScan => true,
      // A scan is in progress, so it can be stopped.
      .scanning => true,
      // The scan is already being aborted.
      .stoppingScan => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: delegate.isScanning,
      stream: delegate.isScanningStream,
      builder: (context, snapshot) {
        final isScanning = snapshot.data ?? false;

        return ValueListenableBuilder(
          valueListenable: delegate.scanningStateListenable,
          builder: (context, state, _) {
            final translator = S.of(context);

            return ScanButton(
              onPressed: _isButtonEnabled(state) ? () => delegate.maybeSkipScan(isScanning: isScanning) : null,
              text: isScanning ? translator.skipScan : translator.continueLabel,
            );
          },
        );
      },
    );
  }
}
