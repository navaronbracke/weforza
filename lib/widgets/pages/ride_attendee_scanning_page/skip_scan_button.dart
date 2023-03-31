import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget provides a button that advances the scan process step.
/// When the scan is still running it gets skipped.
class SkipScanButton extends StatelessWidget {
  const SkipScanButton({
    Key? key,
    required this.isScanning,
    required this.onContinue,
    required this.onSkip,
  }) : super(key: key);

  final Stream<bool> isScanning;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: true,
      stream: isScanning,
      builder: (context, snapshot) => Center(
        child: snapshot.data!
            ? _buildSkipScanButton(context)
            : _buildContinueButton(context),
      ),
    );
  }

  Widget _buildSkipScanButton(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          onPressed: onSkip,
          child: Text(translator.SkipScan),
        ),
      ),
      ios: () {
        final double bottomPadding = MediaQuery.of(context).padding.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding + 20, top: 10),
          child: CupertinoButton.filled(
            onPressed: onSkip,
            child: Text(
              translator.SkipScan,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          onPressed: onContinue,
          child: Text(translator.Continue),
        ),
      ),
      ios: () {
        final double bottomPadding = MediaQuery.of(context).padding.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding + 20, top: 10),
          child: CupertinoButton.filled(
            onPressed: onContinue,
            child: Text(
              translator.Continue,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
