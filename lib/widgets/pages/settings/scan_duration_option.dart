import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ScanDurationOption extends StatefulWidget {
  const ScanDurationOption({
    Key? key,
    required this.getValue,
    required this.minScanValue,
    required this.maxScanValue,
    required this.onChanged,
  })  : assert(minScanValue > 0 && maxScanValue > minScanValue),
        super(key: key);

  final void Function(double value) onChanged;
  final double minScanValue;
  final double maxScanValue;
  final double Function() getValue;

  @override
  _ScanDurationOptionState createState() => _ScanDurationOptionState();
}

class _ScanDurationOptionState extends State<ScanDurationOption> {
  @override
  Widget build(BuildContext context) {
    final currentValue = widget.getValue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).SettingsScanSliderHeader,
          style: ApplicationTheme.settingsOptionHeaderStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
          child: PlatformAwareWidget(
            android: () => SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  trackHeight: 5,
                  thumbColor: ApplicationTheme.settingsScanSliderThumbColor),
              child: Slider(
                value: currentValue,
                onChanged: (value) => setState(() => widget.onChanged(value)),
                min: widget.minScanValue,
                max: widget.maxScanValue,
                divisions: 5,
              ),
            ),
            ios: () => Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoSlider(
                    value: currentValue,
                    onChanged: (value) =>
                        setState(() => widget.onChanged(value)),
                    min: widget.minScanValue,
                    max: widget.maxScanValue,
                    divisions: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(child: Text('${currentValue.floor()}s')),
      ],
    );
  }
}
