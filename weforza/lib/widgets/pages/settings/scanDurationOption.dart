import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

abstract class ScanDurationHandler {
  double get maxScanValue;

  double get minScanValue;

  void Function(double value) onChanged;

  double get currentValue;
}

class ScanDurationOption extends StatefulWidget {
  ScanDurationOption(this.handler): assert(handler != null);

  final ScanDurationHandler handler;

  @override
  _ScanDurationOptionState createState() => _ScanDurationOptionState();
}

class _ScanDurationOptionState extends State<ScanDurationOption> {

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(S.of(context).SettingsScanSliderHeader,style: ApplicationTheme.settingsOptionHeaderStyle),
      SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 5,
            thumbColor: ApplicationTheme.settingsScanSliderThumbColor
          ),
          child: Slider.adaptive(
            value: widget.handler.currentValue,
            onChanged: (value){
              setState(() {
                widget.handler.onChanged(value);
              });
            },
            min: widget.handler.minScanValue,
            max: widget.handler.maxScanValue,
            divisions: 5,
          ),
        ),
      ),
      Center(child: Text("${widget.handler.currentValue.floor()}s")),
    ],
  );
}
