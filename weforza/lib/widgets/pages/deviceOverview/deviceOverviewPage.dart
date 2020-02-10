import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/deviceOverviewBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/pages/deviceOverview/deviceList/deviceOverviewDevicesList.dart';
import 'package:weforza/widgets/platform/orientationAwareWidget.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class DeviceOverviewPage extends StatefulWidget {
  DeviceOverviewPage(this.bloc): assert(bloc != null);

  final DeviceOverviewBloc bloc;

  @override
  _DeviceOverviewPageState createState() => _DeviceOverviewPageState();
}

class _DeviceOverviewPageState extends State<DeviceOverviewPage> {

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
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
      child: _buildBody()
    );
  }

  Widget _buildBody(){
    return StreamBuilder<DeviceOverviewDisplayMode>(
      initialData: DeviceOverviewDisplayMode.ADD,
      builder: (context,snapshot){
        switch(snapshot.data){
          case DeviceOverviewDisplayMode.ADD: return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: null,//TODO addForm
                ),
                Flexible(
                  flex: 2,
                  child: DeviceOverviewDevicesList(widget.bloc),
                )
              ],
            ),
          );
          case DeviceOverviewDisplayMode.EDIT: return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: null,//TODO editForm
                ),
                Flexible(
                  flex: 2,
                  child: DeviceOverviewDevicesList(widget.bloc),
                )
              ],
            ),
          );
          case DeviceOverviewDisplayMode.DELETE: return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: null,//TODO deleteForm
                ),
                Flexible(
                  flex: 2,
                  child: DeviceOverviewDevicesList(widget.bloc),
                )
              ],
            ),
          );
          default: return Center();
        }
      }
    );
  }
}
