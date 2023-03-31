import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ScanDurationOption extends StatelessWidget {
  const ScanDurationOption({
    Key? key,
    required this.initialScanDuration,
    required this.onChanged,
    required this.stream,
  }) : super(key: key);

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
              style: ApplicationTheme.settingsOptionHeaderStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 4),
              child: PlatformAwareWidget(
                android: () => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 5,
                    thumbColor: ApplicationTheme.settingsScanSliderThumbColor,
                  ),
                  child: Slider(
                    value: currentScanDuration,
                    onChanged: onChanged,
                    min: minScanDuration,
                    max: maxScanDuration,
                    divisions: 5,
                  ),
                ),
                ios: () => Row(
                  children: <Widget>[
                    Expanded(
                      child: CupertinoSlider(
                        value: currentScanDuration,
                        onChanged: onChanged,
                        min: minScanDuration,
                        max: maxScanDuration,
                        divisions: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(child: Text('${currentScanDuration.floor()}s')),
          ],
        );
      },
    );
  }
}
