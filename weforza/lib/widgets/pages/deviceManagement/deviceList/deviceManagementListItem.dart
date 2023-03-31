
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/deviceManagement/iDeviceManager.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class DeviceManagementListItem extends StatefulWidget {
  DeviceManagementListItem({
    @required ValueKey<String> key,
    @required this.device,
    @required this.deviceManager,
    @required this.index,
  }): assert(
    key != null && device != null && deviceManager != null && index != null
  ), super(key: key);

  final int index;
  final Device device;
  final IDeviceManager deviceManager;

  @override
  _DeviceManagementListItemState createState() => _DeviceManagementListItemState();
}

class _DeviceManagementListItemState extends State<DeviceManagementListItem> {

  Widget _mapDeviceTypeToIcon(){
    switch(widget.device.type){
      case DeviceType.HEADSET: return Icon(Icons.headset,color: ApplicationTheme.deviceIconColor);
      case DeviceType.WATCH: return Icon(Icons.watch,color: ApplicationTheme.deviceIconColor);
      case DeviceType.TABLET: return Icon(Icons.tablet,color: ApplicationTheme.deviceIconColor);
      case DeviceType.PHONE: return Icon(Icons.smartphone,color: ApplicationTheme.deviceIconColor);
      case DeviceType.GPS: return Icon(Icons.gps_fixed,color: ApplicationTheme.deviceIconColor);
      case DeviceType.PULSE_MONITOR: return Icon(Icons.favorite_border,color: ApplicationTheme.deviceIconColor);
      default: return Icon(Icons.device_unknown,color: ApplicationTheme.deviceIconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: ()=> widget.deviceManager.requestDeleteForm(widget.device, widget.index),
      child: Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(4),
              child: _mapDeviceTypeToIcon(),
            ),
            Expanded(
              child: Text(widget.device.name),
            ),
            _buildButton()
          ],
        ),
      ),
    );
  }

  Widget _buildButton(){
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(Icons.edit),
        onPressed: (){
          widget.deviceManager.requestEditForm(
              widget.device, (editedDevice) => updateItem(editedDevice)
          );
        },

      ),
      ios: () => CupertinoIconButton(
        onPressedColor: ApplicationTheme.primaryColor,
        idleColor: ApplicationTheme.accentColor,
        icon: Icons.edit,
        onPressed: (){
          widget.deviceManager.requestEditForm(
              widget.device, (editedDevice) => updateItem(editedDevice)
          );
        },
      ),
    );
  }

  void updateItem(Device device)=> widget.deviceManager.updateDevice(device,widget.index);

}
