import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ManualSelectionSubmit extends StatelessWidget {
  ManualSelectionSubmit({
    @required this.onSave,
    @required this.isSaving
  }): assert(onSave != null && isSaving != null);

  final void Function() onSave;
  final ValueNotifier<bool> isSaving;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: ValueListenableBuilder<bool>(
            valueListenable: isSaving,
            builder: (context, value, child)=> value ? PlatformAwareLoadingIndicator():
            FlatButton(
                child: Text(
                    S.of(context).RideAttendeeScanningSaveManualResults,
                    style: TextStyle(color: ApplicationTheme.primaryColor)),
              onPressed: onSave,
            ),
          ),
        ),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: Center(
          child: ValueListenableBuilder<bool>(
            valueListenable: isSaving,
            builder: (context, value, child)=> value ?
            PlatformAwareLoadingIndicator(): CupertinoButton(
              child: Text(
                  S.of(context).RideAttendeeScanningSaveManualResults,
                  style: TextStyle(color: ApplicationTheme.primaryColor)
              ),
              onPressed: onSave,
            ),
          ),
        ),
      ),
    );
  }
}
