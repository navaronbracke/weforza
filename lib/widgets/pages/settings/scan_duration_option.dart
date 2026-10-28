import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/scan_duration_delegate.dart';
import 'package:weforza/model/settings/user_preferences.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the scan duration slider.
///
/// It provides an interactive slider to change the scan duration,
/// and a centered label under the slider
/// to indicate the current value in seconds.
class ScanDurationOption extends StatelessWidget {
  const new({required this.delegate, super.key});

  /// The delegate that handles changes to the value.
  final ScanDurationDelegate delegate;

  Widget _buildCurrentDurationLabel() {
    return ValueListenableBuilder<double>(
      valueListenable: delegate.listenable,
      builder: (context, value, _) => Text('${value.floor()}s'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: (context) {
        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const .only(bottom: 4),
              child: Text(translator.scanDuration, style: TextTheme.of(context).titleMedium),
            ),
            ValueListenableBuilder<double>(
              valueListenable: delegate.listenable,
              builder: (context, value, _) {
                return Slider(
                  value: value,
                  onChanged: delegate.onValueChanged,
                  min: UserPreferences.minScanDuration,
                  max: UserPreferences.maxScanDuration,
                  divisions: 5,
                );
              },
            ),
            Center(child: _buildCurrentDurationLabel()),
          ],
        );
      },
      ios: (_) {
        return CupertinoFormRow(
          helper: Padding(
            padding: const .only(top: 8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(padding: const .only(left: 6), child: Text(translator.scanDuration)),
                ),
                Padding(padding: const .symmetric(horizontal: 6), child: _buildCurrentDurationLabel()),
              ],
            ),
          ),
          padding: const .all(6),
          child: ValueListenableBuilder<double>(
            valueListenable: delegate.listenable,
            builder: (context, value, _) {
              return SizedBox(
                width: double.infinity,
                child: CupertinoSlider(
                  value: value,
                  onChanged: delegate.onValueChanged,
                  min: UserPreferences.minScanDuration,
                  max: UserPreferences.maxScanDuration,
                  divisions: 5,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
