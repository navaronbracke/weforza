import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ManualSelectionSubmit extends StatelessWidget {
  ManualSelectionSubmit({
    required this.onSave,
    required this.isSaving
  });

  final void Function() onSave;
  final Stream<bool> isSaving;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<bool>(
        stream: isSaving,
        builder: (context, snapshot){
          return PlatformAwareWidget(
            android: () => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: snapshot.data! ? PlatformAwareLoadingIndicator() : TextButton(
                child: Text(S.of(context).Save),
                onPressed: onSave,
              ),
            ),
            ios: () => Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: snapshot.data! ? PlatformAwareLoadingIndicator() : CupertinoButton(
                child: Text(
                    S.of(context).Save,
                    style: TextStyle(color: ApplicationTheme.primaryColor)
                ),
                onPressed: onSave,
              ),
            ),
          );
        },
      ),
    );
  }
}
