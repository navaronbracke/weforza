import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents the toggle for showing or hiding
/// the scanned results on the manual selection page.
class ShowScannedResultsToggle extends StatelessWidget {
  const ShowScannedResultsToggle({
    required this.initialValue,
    required this.onChanged,
    required this.stream,
    super.key,
  });

  /// The initial value for the toggle switch.
  final bool initialValue;

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
          android: (_) {
            const theme = AppTheme.manualSelectionBottomBar;

            return Switch(
              activeColor: Colors.white,
              activeTrackColor: theme.switchActiveTrackColor,
              onChanged: onChanged,
              value: showScannedResults,
            );
          },
          ios: (_) => CupertinoSwitch(
            onChanged: onChanged,
            value: showScannedResults,
          ),
        );
      },
    );
  }
}
