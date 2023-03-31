import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesList/memberDevicesListDisabledItem.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesList/memberDevicesListEmpty.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesList/memberDevicesListHeader.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesList/memberDevicesListItem.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class MemberDevicesList extends StatefulWidget {
  MemberDevicesList({
    @required this.future,
    @required this.onDeleteDevice
  }): assert(future != null && onDeleteDevice != null);

  final Future<List<Device>> future;
  final Future<void> Function(Device device) onDeleteDevice;

  @override
  _MemberDevicesListState createState() => _MemberDevicesListState();
}

class _MemberDevicesListState extends State<MemberDevicesList> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Device>>(
      future: widget.future,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return GenericError(
                text: S.of(context).MemberDetailsLoadDevicesError
            );
          }else{
            return snapshot.data.isEmpty ? MemberDevicesListEmpty():
              _buildDevicesList(context, snapshot.data);
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  Widget _buildDevicesList(BuildContext context, List<Device> devices){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MemberDevicesListHeader(),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: devices.length,
            itemBuilder: (context,index, animation) => MemberDevicesListItem(
              device: devices[index],
              index: index,
              onDelete: (device, index) => onDeleteDevice(context,device,index,devices),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onDeleteDevice(BuildContext context, Device device, int index, List<Device> devices){
    //delete it from the database
    return widget.onDeleteDevice(device).then((_){
      Navigator.of(context).pop();//get rid of the dialog
      if(_listKey.currentState != null){
        final device = devices.removeAt(index);//remove it from memory
        //and remove it from the animated list
        _listKey.currentState.removeItem(index, (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: MemberDevicesListDisabledItem(device: device),
        ));
        if(devices.isEmpty){
          setState(() {});//switch to the is empty list widget
        }
      }
    });
  }
}

