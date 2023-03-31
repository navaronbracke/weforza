
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/editDevice/editDevicePage.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class MemberDevicesListItem extends StatefulWidget {
  MemberDevicesListItem({@required this.device}): assert(device != null);

  //Initial value from the list builder
  final Device device;

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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

