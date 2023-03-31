import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the toggle for showing or hiding
/// the scanned results on the manual selection page.
class ShowScannedResultsToggle extends StatelessWidget {
  const ShowScannedResultsToggle({
    super.key,
    this.initialValue,
    required this.onChanged,
    required this.stream,
  });

  /// The initial value for the toggle switch.
  final bool? initialValue;

  /// The handler for changes to the toggle value.
  final void Function(bool) onChanged;

  /// The stream that provides updates for the state of the toggle switch.
  final Stream<bool> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: initialValue,
      stream: stream,
      builder: (context, snapshot) {
        final showScannedResults = snapshot.data!;

        return PlatformAwareWidget(
          android: () => Switch(
            activeColor: Colors.white,
            activeTrackColor:
                ApplicationTheme.androidManualSelectionSwitchActiveTrackColor,
            onChanged: onChanged,
            value: showScannedResults,
          ),
          ios: () => CupertinoSwitch(
            onChanged: onChanged,
            value: showScannedResults,
          ),
        );
      },
    );
  }
}
