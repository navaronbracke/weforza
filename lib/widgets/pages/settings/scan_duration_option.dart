import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/scan_duration_delegate.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ScanDurationOption extends StatefulWidget {
  const ScanDurationOption({
    Key? key,
    required this.delegate,
  }) : super(key: key);

  final ScanDurationDelegate delegate;

  @override
  _ScanDurationOptionState createState() => _ScanDurationOptionState();
}

class _ScanDurationOptionState extends State<ScanDurationOption> {
  @override
  Widget build(BuildContext context) {
    final currentValue = widget.delegate.value;

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
                thumbColor: ApplicationTheme.settingsScanSliderThumbColor,
              ),
              child: Slider(
                value: currentValue,
                onChanged: (value) {
                  setState(() => widget.delegate.onChanged(value));
                },
                min: widget.delegate.min,
                max: widget.delegate.max,
                divisions: 5,
              ),
            ),
            ios: () => Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoSlider(
                    value: currentValue,
                    onChanged: (value) {
                      setState(() => widget.delegate.onChanged(value));
                    },
                    min: widget.delegate.min,
                    max: widget.delegate.max,
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
