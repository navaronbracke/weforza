import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the toggle for showing or hiding
/// the scanned results on the manual selection page.
class ShowScannedResultsToggle extends StatelessWidget {
  const ShowScannedResultsToggle({required this.onChanged, required this.listenable, super.key});

  /// The handler for changes to the toggle value.
  final void Function({required bool value}) onChanged;

  /// The [ValueListenable] that provides updates for the state of the toggle switch.
  final ValueListenable<bool> listenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: listenable,
      builder: (context, showScannedResults, _) => PlatformAwareWidget(
        android: (_) => Switch(
          onChanged: (value) => onChanged(value: value),
          value: showScannedResults,
        ),
        ios: (_) => CupertinoSwitch(
          onChanged: (value) => onChanged(value: value),
          value: showScannedResults,
        ),
      ),
    );
  }
}
