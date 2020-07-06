
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/deleteItemDialog/deleteItemDialog.dart';
import 'package:weforza/widgets/pages/editDevice/editDevicePage.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class MemberDevicesListItem extends StatefulWidget {
  MemberDevicesListItem({
    @required this.device,
    @required this.onDelete,
    @required this.index,
  }): assert(device != null && onDelete != null && index != null);

  //Initial value from the list builder
  final Device device;
  final int index;
  final Future<void> Function(String deviceName, int index) onDelete;

  @override
  _MemberDevicesListItemState createState() => _MemberDevicesListItemState();
}

class _MemberDevicesListItemState extends State<MemberDevicesListItem> {
  //Device field that can be updated when the device is edited.
  Device device;

  @override
  void initState(){
    super.initState();
    //Set the initial data
    device = widget.device;
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => GestureDetector(
      onLongPress: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => DeleteItemDialog(
            title: S.of(context).DeleteDeviceTitle,
            description: S.of(context).DeleteDeviceDescription,
            errorDescription: S.of(context).DeleteDeviceErrorDescription,
            onDelete: () => widget.onDelete(device.name, widget.index),
          ),
      ),
      child: _buildItem(context),
    ),
    ios: () => GestureDetector(
      onLongPress: () => showCupertinoDialog(
        context: context,
        builder: (_) => DeleteItemDialog(
          title: S.of(context).DeleteDeviceTitle,
          description: S.of(context).DeleteDeviceDescription,
          errorDescription: S.of(context).DeleteDeviceErrorDescription,
          onDelete: () => widget.onDelete(device.name, widget.index),
        ),
      ),
      child: _buildItem(context),
    ),
  );

  Widget _buildItem(BuildContext context){
    return Container(
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: _mapDeviceTypeToIcon(),
            ),
            Expanded(
                child: Text(device.name, overflow: TextOverflow.ellipsis)
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: _buildEditDeviceButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapDeviceTypeToIcon(){
    switch(device.type){
      case DeviceType.HEADSET: return Icon(Icons.headset,color: ApplicationTheme.deviceIconColor);
      case DeviceType.WATCH: return Icon(Icons.watch,color: ApplicationTheme.deviceIconColor);
      case DeviceType.TABLET: return Icon(Icons.tablet,color: ApplicationTheme.deviceIconColor);
      case DeviceType.PHONE: return Icon(Icons.smartphone,color: ApplicationTheme.deviceIconColor);
      case DeviceType.GPS: return Icon(Icons.gps_fixed,color: ApplicationTheme.deviceIconColor);
      case DeviceType.PULSE_MONITOR: return Icon(Icons.favorite_border,color: ApplicationTheme.deviceIconColor);
      default: return Icon(Icons.device_unknown,color: ApplicationTheme.deviceIconColor);
    }
  }

  Widget _buildEditDeviceButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(
            Icons.edit,
            color: ApplicationTheme.memberDevicesListEditDeviceColor
        ),
        onPressed: (){
          SelectedItemProvider.of(context).selectedDevice.value = device;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditDevicePage())).then((editedDevice){
            if(editedDevice != null){
              setState(() {
                device = editedDevice;
              });
            }
          });
        },
      ),
      ios: () => CupertinoIconButton(
        idleColor: ApplicationTheme.memberDevicesListEditDeviceIdleColor,
        onPressedColor: ApplicationTheme.memberDevicesListEditDevicePressedColor,
        onPressed: (){
          SelectedItemProvider.of(context).selectedDevice.value = device;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditDevicePage())).then((editedDevice){
            if(editedDevice != null){
              setState(() {
                device = editedDevice;
              });
            }
          });
        },
        icon: Icons.edit,
      ),
    );
  }
}

