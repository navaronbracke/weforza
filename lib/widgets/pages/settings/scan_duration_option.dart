import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/theme.dart';

class ScanDurationOption extends StatelessWidget {
  const ScanDurationOption({
    super.key,
    required this.initialScanDuration,
    required this.onChanged,
    required this.stream,
  });

  final double initialScanDuration;

  final double maxScanDuration = 60;

  final double minScanDuration = 10;

  final void Function(double value) onChanged;

  final Stream<double> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: initialScanDuration,
      stream: stream,
      builder: (context, snapshot) {
        final currentScanDuration = snapshot.data!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).SettingsScanSliderHeader,
              style: AppTheme.settings.optionHeaderStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 4),
              child: Slider.adaptive(
                value: currentScanDuration,
                onChanged: onChanged,
                min: minScanDuration,
                max: maxScanDuration,
                divisions: 5,
              ),
            ),
            Center(child: Text('${currentScanDuration.floor()}s')),
          ],
        );
      },
    );
  }
}
