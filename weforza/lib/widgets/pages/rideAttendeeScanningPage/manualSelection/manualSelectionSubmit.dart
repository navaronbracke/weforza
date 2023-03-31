import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionItemCounter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ManualSelectionSubmit extends StatelessWidget {
  ManualSelectionSubmit({
    required this.onSave,
    required this.isSaving,
    required this.attendeeCountStream,
    required this.getAttendeeCount,
    required this.bottomInset,
  });

  final void Function() onSave;
  final Stream<bool> isSaving;
  final Stream<int> attendeeCountStream;
  final int Function() getAttendeeCount;
  // The bottom inset from the device notch at the bottom.
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ManualSelectionItemCounter(
            backgroundColor: ApplicationTheme.primaryColor,
            countStream: attendeeCountStream,
            initialData: getAttendeeCount(),
          ),
          Expanded(child: Center()),
          _buildAndroidSaveButton(),
        ],
      ),
      ios: (){
        final child = Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ManualSelectionItemCounter(
              backgroundColor: ApplicationTheme.primaryColor,
              countStream: attendeeCountStream,
              initialData: getAttendeeCount(),
            ),
            Expanded(child: Center()),
            _buildIosSaveButton(),
          ],
        );

        return Padding(
          // Push the child away from the screen bottom edge.
          // If there is a bottom inset,
          // the inset can be used for this purpose.
          padding: bottomInset == 0 ? const EdgeInsets.only(bottom: 5) : EdgeInsets.zero,
          child: child,
        );
      },
    );
  }

  Widget _buildAndroidSaveButton() {
    return StreamBuilder<bool>(
      stream: isSaving,
      initialData: false,
      builder: (context, snapshot) {
        return snapshot.data!
            ? Padding(
                padding: const EdgeInsets.only(right: 15, top: 15, bottom: 15),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: ElevatedButton(
                  child: Text(S.of(context).Save),
                  onPressed: onSave,
                ),
              );
      },
    );
  }

  Widget _buildIosSaveButton() {
    return StreamBuilder<bool>(
      stream: isSaving,
      initialData: false,
      builder: (context, snapshot) {
        return snapshot.data!
            ? Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 14),
                child: CupertinoActivityIndicator(radius: 12.5),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 56,
                  ),
                  child: Text(
                    S.of(context).Save,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: onSave,
                ),
              );
      },
    );
  }
}
