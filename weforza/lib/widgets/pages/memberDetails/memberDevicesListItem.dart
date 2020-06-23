
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';

class MemberDevicesListItem extends StatelessWidget {
  MemberDevicesListItem({@required this.device}): assert(device != null);

  final Device device;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: _mapDeviceTypeToIcon(),
          ),
          Expanded(
            child: Text(device.name,overflow: TextOverflow.ellipsis)
          ),
        ],
      ),
    );
  }
}
