import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a button for the ride attendee scanning page.
class ScanButton extends StatelessWidget {
  const ScanButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  final void Function() onPressed;

  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PlatformAwareWidget(
        android: (_) => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(text),
          ),
        ),
        ios: (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CupertinoButton.filled(
            onPressed: onPressed,
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

/// This widget represents a button that stops a scan.
class StopScanButton extends StatelessWidget {
  const StopScanButton({
    required this.delegate,
    super.key,
  });

  /// The delegate that manages the running scan.
  final RideAttendeeScanningDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: delegate.scanner.isScanning,
      builder: (context, snapshot) {
        final isScanning = snapshot.data;
        final translator = S.of(context);

        if (isScanning == null) {
          return const SizedBox.shrink();
        }

        return ScanButton(
          onPressed: () => delegate.maybeSkipScan(isScanning: isScanning),
          text: isScanning ? translator.skipScan : translator.continueLabel,
        );
      },
    );
  }
}
