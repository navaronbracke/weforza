import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class SaveScanOrSkipButton extends StatefulWidget {
  SaveScanOrSkipButton({
    @required this.isScanning,
    @required this.onSave,
    @required this.onSkip,
  }): assert(isScanning != null && onSave != null && onSkip != null);

  final ValueNotifier<bool> isScanning;
  final VoidCallback onSave;
  final VoidCallback onSkip;

  @override
  _SaveScanOrSkipButtonState createState() => _SaveScanOrSkipButtonState();
}

class _SaveScanOrSkipButtonState extends State<SaveScanOrSkipButton> {

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    if(isSaving){
      return PlatformAwareLoadingIndicator();
    }else{
      return ValueListenableBuilder<bool>(
        valueListenable: widget.isScanning,
        builder: (context, isScanning, child){
          return isScanning ? _buildSkipScanButton(context) : _buildSaveButton(context);
        },
      );
    }
  }

  Widget _buildSkipScanButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => FlatButton(
        child: Text(S.of(context).RideAttendeeScanningSkipScan),
        onPressed: widget.onSkip,
      ),
      ios: () => CupertinoButton(
        child: Text(S.of(context).RideAttendeeScanningSkipScan),
        onPressed: widget.onSkip,
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => FlatButton(
        child: Text(S.of(context).RideAttendeeScanningSaveScanResults),
        onPressed: (){
          setState(() {
            isSaving = true;
            widget.onSave();
          });
        },
      ),
      ios: () => CupertinoButton(
        child: Text(S.of(context).RideAttendeeScanningSaveScanResults),
        onPressed: (){
          setState(() {
            isSaving = true;
            widget.onSave();
          });
        },
      ),
    );
  }
}
