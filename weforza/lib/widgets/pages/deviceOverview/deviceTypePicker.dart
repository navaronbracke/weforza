import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class DeviceTypePicker extends StatefulWidget {
  DeviceTypePicker({this.initialValue,@required this.onValueChanged}): assert(onValueChanged != null);

  final void Function(DeviceType value) onValueChanged;
  final DeviceType initialValue;

  @override
  _DeviceTypePickerState createState() => _DeviceTypePickerState();
}

class _DeviceTypePickerState extends State<DeviceTypePicker> {

  List<String> _items;

  DeviceType _value;

  void _initializeItems(BuildContext context){
    _items = <String>[
      S.of(context).DeviceUnknown,
      S.of(context).DevicePulseMonitor,
      S.of(context).DeviceGPS,
      S.of(context).DeviceHeadset,
      S.of(context).DevicePhone,
      S.of(context).DeviceTablet,
      S.of(context).DeviceWatch,
    ];
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context){
    _initializeItems(context);
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Center(child: Text(S.of(context).DeviceSelectType)),
        ),
        Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: ApplicationTheme.choiceArrowIdleColor,
                  splashColor: ApplicationTheme.choiceArrowOnPressedColor,
                  onPressed: () => onTypeBackPressed(),
                ),
                Expanded(
                  child: Center(
                    child: Text(_items[_value.index]),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: ApplicationTheme.choiceArrowIdleColor,
                  splashColor: ApplicationTheme.choiceArrowOnPressedColor,
                  onPressed: () => onTypeForwardPressed(),
                ),
              ],
            ),
            SizedBox(width: 10),
            Text("${_value.index + 1} / ${DeviceType.values.length}"),
          ],
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            CupertinoIconButton(
              icon: Icons.arrow_back_ios,
              idleColor: ApplicationTheme.choiceArrowIdleColor,
              onPressedColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: () => onTypeBackPressed(),
            ),
            Expanded(
              child: Center(
                child: Text(_items[_value.index]),
              ),
            ),
            CupertinoIconButton(
              icon: Icons.arrow_forward_ios,
              idleColor: ApplicationTheme.choiceArrowIdleColor,
              onPressedColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: () => onTypeForwardPressed(),
            ),
          ],
        ),
        SizedBox(width: 10),
        Text("${_value.index + 1} / ${DeviceType.values.length}"),
      ],
    );
  }

  void onTypeForwardPressed(){
    if(_value.index < DeviceType.values.length){
      setState(() {
        _value = DeviceType.values[_value.index + 1];
      });
      widget.onValueChanged(_value);
    }
  }

  void onTypeBackPressed(){
    if(_value.index == 0) return;
    setState(() {
      _value = DeviceType.values[_value.index - 1];
    });
    widget.onValueChanged(_value);
  }
}
