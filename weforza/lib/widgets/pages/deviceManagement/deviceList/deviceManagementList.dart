import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceList/deviceManagementListEmpty.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceList/deviceManagementListItem.dart';
import 'package:weforza/widgets/pages/deviceManagement/iDeviceManager.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';


class DeviceManagementList extends StatefulWidget {
  DeviceManagementList({
    @required Key key,
    @required this.deviceManager,
  }): assert(key != null && deviceManager != null), super(key: key);

  final IDeviceManager deviceManager;

  @override
  DeviceManagementListState createState() => DeviceManagementListState();
}

class DeviceManagementListState extends State<DeviceManagementList> {
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final devices = widget.deviceManager.devices;
    return devices.isEmpty ? DeviceListEmpty() : _buildList(devices);
  }

  Widget _buildList(List<Device> devices){
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
            StreamBuilder<bool>(
              initialData: true,
              stream: widget.deviceManager.isShowingAddDeviceForm,
              builder: (context,snapshot)
                => snapshot.data ? _buildAddDeviceButton(context): Container(),
            ),
          ],
        ),
        Flexible(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: devices.length,
            itemBuilder: (context,index,animation){
              final device = devices[index];
              return SizeTransition(
                  sizeFactor: animation,
                  child: DeviceManagementListItem(
                    key: ValueKey<String>(device.name),
                    device: device,
                    index: index,
                    deviceManager: widget.deviceManager
                  ),
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
        onPressed: ()=> widget.deviceManager.requestAddForm(),
      ),
      ios: () => CupertinoIconButton(
          icon: Icons.add,
          onPressed: ()=> widget.deviceManager.requestAddForm()
      ),
    );
  }

  void insertItem(int index){
    if(widget.deviceManager.devices.length == 1){
      setState(() {
        //trigger a swap from empty list to animated list
      });
    }else{
      if(_listKey.currentState != null){
        _listKey.currentState.insertItem(index);
      }
    }
  }

  void removeItem(int index){
    if(widget.deviceManager.devices.isEmpty){
      setState(() {
        //trigger a swap from animated list to empty list
      });
    }else{
      if(_listKey.currentState != null){
        _listKey.currentState.removeItem(index, (context,animation)=> SizedBox(width: 0,height: 0));
      }
    }
  }
}
