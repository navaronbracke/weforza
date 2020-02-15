import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/addDeviceBloc.dart';
import 'package:weforza/blocs/deviceOverviewBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/provider/deviceProvider.dart';
import 'package:weforza/provider/memberProvider.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/widgets/pages/deviceOverview/addDevice/addDeviceForm.dart';
import 'package:weforza/widgets/pages/deviceOverview/addDevice/addDeviceHandler.dart';
import 'package:weforza/widgets/pages/deviceOverview/deviceList/deviceListEmpty.dart';
import 'package:weforza/widgets/pages/deviceOverview/deviceList/deviceOverviewDevicesList.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class DeviceOverviewPage extends StatefulWidget {
  DeviceOverviewPage(this.bloc): assert(bloc != null);

  final DeviceOverviewBloc bloc;

  @override
  _DeviceOverviewPageState createState() => _DeviceOverviewPageState();
}

class _DeviceOverviewPageState extends State<DeviceOverviewPage> implements AddDeviceHandler {
  final _deviceListKey = GlobalKey<DeviceOverviewDevicesListState>();

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () {
      FocusScope.of(context).unfocus();
      return Future.value(true);
    },
    child: PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    ),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.of(context).DeviceOverviewTitle),
      ),
      body: _buildBody()
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).DeviceOverviewTitle),
      ),
      child: SafeArea(bottom: false,child: _buildBody())
    );
  }

  Widget _buildBody(){
    return StreamBuilder<DeviceOverviewDisplayMode>(
      initialData: DeviceOverviewDisplayMode.ADD,
      builder: (context,snapshot){
        switch(snapshot.data){
          case DeviceOverviewDisplayMode.ADD: return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5),
                child: AddDeviceForm(
                    AddDeviceBloc(
                        MemberProvider.selectedMember.uuid,
                        InjectionContainer.get<DeviceRepository>()
                    ),this
                ),
              ),
              Expanded(
                child: widget.bloc.devices.isEmpty ? DeviceListEmpty(): DeviceOverviewDevicesList(
                    handler: widget.bloc,
                    key: _deviceListKey
                ),
              ),
            ],
          );
          case DeviceOverviewDisplayMode.EDIT: return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              null,//TODO editForm
              widget.bloc.devices.isEmpty ? SingleChildScrollView(
                child: DeviceListEmpty(),
              ) : DeviceOverviewDevicesList(
                handler: widget.bloc,key: _deviceListKey,
              ),
            ],
          );
          case DeviceOverviewDisplayMode.DELETE: return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              null,//TODO deleteForm
              widget.bloc.devices.isEmpty ? SingleChildScrollView(
                child: DeviceListEmpty(),
              ) : DeviceOverviewDevicesList(
                handler: widget.bloc,key: _deviceListKey,
              ),
            ],
          );
          default: return Center();
        }
      }
    );
  }

  @override
  void onDeviceAdded(Device device) {
    DeviceProvider.reloadDevices = true;
    widget.bloc.addDevice(device);
    if(widget.bloc.devices.length == 1){
      setState(() {
        //trigger a swap from empty list to animated list
      });
    }else{
      _deviceListKey.currentState.onItemInserted(widget.bloc.devices.length-1);
    }
  }
}
