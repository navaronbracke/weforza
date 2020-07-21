import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class SaveScanOrSkipButton extends StatelessWidget {
  SaveScanOrSkipButton({
    @required this.isScanning,
    @required this.isSaving,
    @required this.onSave,
    @required this.onSkip,
  }): assert(
    isScanning != null && isSaving != null && onSave != null && onSkip != null
  );

  final ValueNotifier<bool> isScanning;
  final ValueNotifier<bool> isSaving;
  final VoidCallback onSave;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSaving,
      builder: (context, isSaving, child){
        if(isSaving){
          return PlatformAwareLoadingIndicator();
        }else{
          return ValueListenableBuilder<bool>(
            valueListenable: isScanning,
            builder: (context, isScanning, child){
              return isScanning ? Center(child: _buildSkipScanButton(context)) :
               Center(child: _buildSaveButton(context));
            },
          );
        }
      },
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

  Widget _buildSaveButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FlatButton(
          child: Text(
            S.of(context).RideAttendeeScanningSaveScanResults,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onSave,
        ),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: CupertinoButton(
          child: Text(
            S.of(context).RideAttendeeScanningSaveScanResults,
            style: TextStyle(color: ApplicationTheme.primaryColor),
          ),
          onPressed: onSave,
        ),
      ),
    );
  }
}

