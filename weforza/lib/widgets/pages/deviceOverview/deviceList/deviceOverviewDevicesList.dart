import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/pages/deviceOverview/deviceList/deviceListItem.dart';
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


  ///This method is called when an item is inserted and [widget.devices] is not empty.
  void onItemInserted(int index){
    if(_listKey.currentState != null){
      _listKey.currentState.insertItem(index);
    }
  }

  ///This method is called when an item is removed and [widget.devices] still has items afterwards.
  void onItemRemoved(int index){
    if(_listKey.currentState != null){
      _listKey.currentState.removeItem(index, (context,animation)=> SizedBox(width: 0,height: 0));
    }
  }


  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(S.of(context).DevicesHeader,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
              ),
            ),
            _buildAddDeviceButton(context),
          ],
        ),
        Flexible(
          child: AnimatedList(
            key: _listKey,
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

  Widget _buildAddDeviceButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(Icons.add),
        onPressed: (){
          //TODO change upper form to add
        },
      ),
      ios: () => CupertinoIconButton(
          icon: Icons.add,
          onPressed: (){
            //TODO change upper form to add
          }
      ),
    );
  }
}

