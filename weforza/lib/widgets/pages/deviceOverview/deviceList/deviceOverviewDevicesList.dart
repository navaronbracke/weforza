import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class DeviceOverviewDevicesList extends StatefulWidget {
  DeviceOverviewDevicesList({@required this.devices, @required Key key}): assert(devices != null), super(key: key);

  final List<Device> devices;

  @override
  DeviceOverviewDevicesListState createState() => DeviceOverviewDevicesListState();
}

///The [State] for [DeviceOverviewDevicesList].
///This class is public because it handles updating the list and this is handled from outside the State.
///Hence we need access to the current state,through the key.
class DeviceOverviewDevicesListState extends State<DeviceOverviewDevicesList> {
  final _listKey = GlobalKey<AnimatedListState>();

  ///This method triggers a redraw, once [widget.devices] has exactly one item.
  ///This swaps the [AnimatedList] for an empty list widget.
  void onFirstItemInserted() => setState(() {});

  ///This method triggers a redraw, once [widget.devices] is empty.
  ///This swaps the empty list widget for an [AnimatedList].
  void onLastItemRemoved() => onFirstItemInserted();

  ///This method is called when an item is inserted and [widget.devices] is not empty.
  void onItemInserted(int index)=> _listKey.currentState.insertItem(index);

  ///This method is called when an item is removed and [widget.devices] still has items afterwards.
  void onItemRemoved(int index){
    _listKey.currentState.removeItem(index, (context,animation)=> SizedBox(width: 0,height: 0));
  }


  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context){
    return (widget.devices.isEmpty) ? Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.priority_high,
              color: ApplicationTheme.deviceIconColor,
              size: MediaQuery.of(context).size.shortestSide * .2,
            ),
            SizedBox(height: 5),
            Text(S.of(context).DeviceOverviewNoDevices),
          ],
        ),
      ),
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
            initialItemCount: widget.devices.length,
            itemBuilder: (context,index,animation){
              return SizeTransition(
                  sizeFactor: animation,
                  child: DeviceOverviewDeviceListItem(widget.devices[index])
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context){
    return (widget.devices.isEmpty) ? Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.priority_high,
              color: ApplicationTheme.deviceIconColor,
              size: MediaQuery.of(context).size.shortestSide * .2,
            ),
            SizedBox(height: 5),
            Text(S.of(context).DeviceOverviewNoDevices),
          ],
        ),
      ),
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
                //TODO change upper form to add
              }
            ),
          ],
        ),
        Expanded(
          child: AnimatedList(
            initialItemCount: widget.devices.length,
            itemBuilder: (context,index,animation){
              return SizeTransition(
                  sizeFactor: animation,
                  child: DeviceOverviewDeviceListItem(widget.devices[index])
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

