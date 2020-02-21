

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class DeviceOverviewDeviceListItem extends StatefulWidget {
  DeviceOverviewDeviceListItem(this.device): assert(device != null);

  final Device device;

  @override
  _DeviceOverviewDeviceListItemState createState() => _DeviceOverviewDeviceListItemState();
}

class _DeviceOverviewDeviceListItemState extends State<DeviceOverviewDeviceListItem> {

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
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  Widget _buildAndroidWidget(BuildContext context){
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(4),
          child: _mapDeviceTypeToIcon(),
        ),
        Expanded(
          child: Text(widget.device.name),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: (){
            //TODO on edit callback
          },
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context){
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(4),
          child: _mapDeviceTypeToIcon(),
        ),
        Expanded(
          child: Text(widget.device.name),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: CupertinoIconButton(
              icon: Icons.edit,
              onPressed: (){
                //TODO on edit callback
              }
          ),
        )
      ],
    );
  }
}