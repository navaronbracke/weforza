import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/scan_duration_delegate.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the scan duration slider.
///
/// It provides an interactive slider to change the scan duration,
/// and a centered label under the slider
/// to indicate the current value in seconds.
class ScanDurationOption extends StatelessWidget {
  const ScanDurationOption({
    required this.delegate,
    super.key,
  });

  /// The delegate that handles changes to the value.
  final ScanDurationDelegate delegate;

  /// The maximum scan duration of 60 seconds.
  final double maxScanDuration = 60;

  /// The minimum scan duration of 10 seconds.
  final double minScanDuration = 10;

  Widget _buildCurrentDurationLabel() {
    return StreamBuilder<double>(
      initialData: delegate.currentValue,
      stream: delegate.stream,
      builder: (context, snapshot) => Text('${snapshot.data!.floor()}s'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              translator.scanDuration,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          StreamBuilder<double>(
            initialData: delegate.currentValue,
            stream: delegate.stream,
            builder: (context, snapshot) => Slider(
              value: snapshot.data!,
              onChanged: delegate.onValueChanged,
              min: minScanDuration,
              max: maxScanDuration,
              divisions: 5,
            ),
          ),
          Center(child: _buildCurrentDurationLabel()),
        ],
      ),
      ios: (_) => CupertinoFormRow(
        helper: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(translator.scanDuration),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildCurrentDurationLabel(),
              ),
            ],
          ),
        ),
        padding: const EdgeInsets.all(6),
        child: StreamBuilder<double>(
          initialData: delegate.currentValue,
          stream: delegate.stream,
          builder: (context, snapshot) => SizedBox(
            width: double.infinity,
            child: CupertinoSlider(
              value: snapshot.data!,
              onChanged: delegate.onValueChanged,
              min: minScanDuration,
              max: maxScanDuration,
              divisions: 5,
            ),
          ),
        ),
      ),
    );
  }
}
