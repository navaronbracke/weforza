import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

/// This widget provides a button that advances the scan process step.
/// When the scan is still running it gets skipped.
class SkipScanButton extends StatelessWidget {
  SkipScanButton({
    required this.isScanning,
    required this.onContinue,
    required this.onSkip,
  });

  final Stream<bool> isScanning;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: true,
      stream: isScanning,
      builder: (context, snapshot) => Center(
        child: snapshot.data! ? _buildSkipScanButton(context):
          _buildContinueButton(context),
      ),
    );
  }

  Widget _buildSkipScanButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          child: Text(S.of(context).RideAttendeeScanningSkipScan),
          onPressed: onSkip,
        ),
      ),
      ios: (){
        final double bottomPadding = MediaQuery.of(context).padding.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding + 20, top: 10),
          child: CupertinoButton.filled(
            child: Text(
              S.of(context).RideAttendeeScanningSkipScan,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onSkip,
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          child: Text(S.of(context).RideAttendeeScanningContinue),
          onPressed: onContinue,
        ),
      ),
      ios: (){
        final double bottomPadding = MediaQuery.of(context).padding.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding + 20, top: 10),
          child: CupertinoButton.filled(
            child: Text(
              S.of(context).RideAttendeeScanningContinue,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onContinue,
          ),
        );
      },
    );
  }
}
