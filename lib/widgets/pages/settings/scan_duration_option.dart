import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the scan duration slider.
///
/// It provides an interactive slider to change the scan duration,
/// and a centered label under the slider
/// to indicate the current value in seconds.
class ScanDurationOption extends StatelessWidget {
  const ScanDurationOption({
    required this.initialValue,
    required this.onChanged,
    required this.stream,
    super.key,
  });

  /// The initially selected scan duration, in seconds.
  final double initialValue;

  /// The maximum scan duration of 60 seconds.
  final double maxScanDuration = 60;

  /// The minimum scan duration of 10 seconds.
  final double minScanDuration = 10;

  /// The handler function that is called when the value changes.
  final void Function(double value) onChanged;

  /// The stream that provides updates about the current value.
  final Stream<double> stream;

  Widget _buildCurrentDurationLabel() {
    return StreamBuilder<double>(
      initialData: initialValue,
      stream: stream,
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
              translator.ScanDuration,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          StreamBuilder<double>(
            initialData: initialValue,
            stream: stream,
            builder: (context, snapshot) => Slider(
              value: snapshot.data!,
              onChanged: onChanged,
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
                  child: Text(translator.ScanDuration),
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
          initialData: initialValue,
          stream: stream,
          builder: (context, snapshot) => SizedBox(
            width: double.infinity,
            child: CupertinoSlider(
              value: snapshot.data!,
              onChanged: onChanged,
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
