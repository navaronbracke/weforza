import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

/// This widget provides a button that advances the scan process step.
/// When the scan is still running it gets skipped.
class SkipScanButton extends StatelessWidget {
  SkipScanButton({
    @required this.isScanning,
    @required this.onPressed,
    @required this.onSkip,
  }): assert(isScanning != null && onPressed != null && onSkip != null);

  final ValueNotifier<bool> isScanning;
  final VoidCallback onPressed;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isScanning,
      builder: (context, isScanning, child) => Center(
          child: isScanning ? _buildSkipScanButton(context): _buildContinueButton(context),
      ),
    );
  }

  Widget _buildSkipScanButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FlatButton(
          child: Text(
            S.of(context).RideAttendeeScanningSkipScan,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onSkip,
        ),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: CupertinoButton(
          child: Text(
            S.of(context).RideAttendeeScanningSkipScan,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onSkip,
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FlatButton(
          child: Text(
            S.of(context).RideAttendeeScanningContinue,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onPressed,
        ),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: CupertinoButton(
          child: Text(
            S.of(context).RideAttendeeScanningContinue,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
