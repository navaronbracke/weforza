import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class DeviceTypePicker extends StatefulWidget {
  DeviceTypePicker({this.initialValue,@required this.onValueChanged}): assert(onValueChanged != null);

  final void Function(DeviceType value) onValueChanged;
  final DeviceType initialValue;

  @override
  _DeviceTypePickerState createState() => _DeviceTypePickerState();
}

class _DeviceTypePickerState extends State<DeviceTypePicker> {

  ///A map that holds the information to build the items.
  Map<DeviceType,String> _itemMap;

  DeviceType _dropdownValue;

  void _initializeDropdownItems(BuildContext context){
    _itemMap = {
      DeviceType.UNKNOWN: S.of(context).DeviceUnknown,
      DeviceType.PULSE_MONITOR: S.of(context).DevicePulseMonitor,
      DeviceType.GPS: S.of(context).DeviceGPS,
      DeviceType.HEADSET: S.of(context).DeviceHeadset,
      DeviceType.PHONE: S.of(context).DevicePhone,
      DeviceType.TABLET: S.of(context).DeviceTablet,
      DeviceType.WATCH: S.of(context).DeviceWatch,
    };
  }

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context){
    _initializeDropdownItems(context);
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return DropdownButton<DeviceType>(
      value: _dropdownValue,
      onChanged: _dropdownValue == null ? null : (DeviceType newValue) {
        setState(() {
          _dropdownValue = newValue;
          widget.onValueChanged(_dropdownValue);
        });
      },
      items: DeviceType.values.map((DeviceType type)=> DropdownMenuItem<DeviceType>(
        child: Text(_itemMap[type]),
        value: type,
      )).toList()
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return (_dropdownValue == null) ?
    CupertinoPicker.builder(
      itemExtent: 4,
      onSelectedItemChanged: null,
      itemBuilder: (context,index)=> Text(_itemMap[DeviceType.values[index]]),
      childCount: DeviceType.values.length,
    ): CupertinoPicker.builder(
        scrollController: FixedExtentScrollController(initialItem: _dropdownValue.index),
        itemExtent: 4,
        itemBuilder: (context,index)=> Text(_itemMap[DeviceType.values[index]]),
        childCount: DeviceType.values.length,
        onSelectedItemChanged: (index){
          setState(() {
            _dropdownValue = DeviceType.values[index];
            widget.onValueChanged(_dropdownValue);
          });
      },
    );
  }
}
