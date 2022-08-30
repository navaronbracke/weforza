import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a button that stops a scan.
class StopScanButton extends StatelessWidget {
  const StopScanButton({super.key, required this.delegate});

  /// The delegate that manages the running scan.
  final RideAttendeeScanningDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<bool>(
        stream: delegate.scanner.isScanning,
        builder: (context, snapshot) {
          final isScanning = snapshot.data!;
          final translator = S.of(context);
          final text = isScanning ? translator.SkipScan : translator.Continue;

          return PlatformAwareWidget(
            android: () => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () => delegate.maybeSkipScan(isScanning: isScanning),
                child: Text(text),
              ),
            ),
            ios: () => _CupertinoStopScanButton(
              onPressed: () => delegate.maybeSkipScan(isScanning: isScanning),
              text: text,
            ),
          );
        },
      ),
    );
  }
}

/// This widget represents the iOS implementation of the stop scan button.
class _CupertinoStopScanButton extends StatelessWidget {
  const _CupertinoStopScanButton({required this.onPressed, required this.text});

  final void Function() onPressed;

  final String text;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding + 20, top: 8),
      child: CupertinoButton.filled(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
