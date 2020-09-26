import 'package:flutter/material.dart';
import 'package:weforza/blocs/memberDetailsBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/pages/addDevice/addDevicePage.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesList/memberDevicesListDisabledItem.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesList/memberDevicesListEmpty.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesList/memberDevicesListHeader.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesList/memberDevicesListItem.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';

class MemberDevicesList extends StatefulWidget {
  MemberDevicesList({
    @required this.bloc,
  }): assert(bloc != null);

  final MemberDetailsBloc bloc;

  @override
  _MemberDevicesListState createState() => _MemberDevicesListState();
}

class _MemberDevicesListState extends State<MemberDevicesList> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Device>>(
      future: widget.bloc.devicesFuture,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return GenericError(
                text: S.of(context).MemberDetailsLoadDevicesError
            );
          }else{
            return snapshot.data.isEmpty ?
            MemberDevicesListEmpty(onPressed: () => goToAddDevicePage(context)):
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
      children: <Widget>[
        MemberDevicesListHeader(
          onPressed: () => goToAddDevicePage(context),
        ),
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

  void goToAddDevicePage(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> AddDevicePage())).then((_){
          final reloadDevicesNotifier = ReloadDataProvider.of(context).reloadDevices;
          if(reloadDevicesNotifier.value){
            reloadDevicesNotifier.value = false;
            setState(() => widget.bloc.reloadDevices());
        }
      }
    );
  }

  Future<void> onDeleteDevice(BuildContext context, Device device, int index, List<Device> devices){
    //delete it from the database
    return widget.bloc.deleteDevice(device).then((_){
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

