import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/deviceOverview/deviceList/deviceListHandler.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';


class DeviceOverviewDevicesList extends StatefulWidget {
  DeviceOverviewDevicesList(this.handler): assert(handler != null);

  final DeviceListHandler handler;

  @override
  _DeviceOverviewDevicesListState createState() => _DeviceOverviewDevicesListState();
}

class _DeviceOverviewDevicesListState extends State<DeviceOverviewDevicesList> {
  final _listKey = GlobalKey<AnimatedListState>();


  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context){
    final devices = widget.handler.devices;
    return (devices.isEmpty) ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.priority_high,
          color: ApplicationTheme.deviceIconColor,
          size: MediaQuery.of(context).size.shortestSide * .2,
        ),
        SizedBox(height: 5),
        Text(S.of(context).DeviceOverviewNoDevices),
      ],
    ): Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(S.of(context).DevicesHeader),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                //TODO change upper form to add
              },
            ),
          ],
        ),
        Expanded(
          child: AnimatedList(
            initialItemCount: devices.length,
            itemBuilder: (context,index,animation){
              return FadeTransition(
                  opacity: animation,
                  child: DeviceOverviewDeviceListItem(devices[index])
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context){
    final devices = widget.handler.devices;
    return (devices.isEmpty) ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.priority_high,
          color: ApplicationTheme.deviceIconColor,
          size: MediaQuery.of(context).size.shortestSide * .2,
        ),
        SizedBox(height: 5),
        Text(S.of(context).DeviceOverviewNoDevices),
      ],
    ): Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(S.of(context).DevicesHeader),
            ),
            CupertinoIconButton(
              icon: Icons.add,
              onPressed: (){
                //TODO on add, register callback too so the list here updates
              }
            ),
          ],
        ),
        Expanded(
          child: AnimatedList(
            initialItemCount: devices.length,
            itemBuilder: (context,index,animation){
              return FadeTransition(
                  opacity: animation,
                  child: DeviceOverviewDeviceListItem(devices[index])
              );
            },
          ),
        ),
      ],
    );
  }
}

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
        CupertinoIconButton(
          icon: Icons.edit,
          onPressed: (){
            //TODO on edit callback
          }
        )
      ],
    );
  }
}

