import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/deviceOverviewBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/deviceOverview/deviceOverviewPage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This widget is shown as replacement of a [Member]'s devices, if it has none.
class MemberDevicesEmpty extends StatelessWidget {
  MemberDevicesEmpty(this._onReload): assert(_onReload != null);

  final VoidCallback _onReload;

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.devices_other,
          color: ApplicationTheme.deviceIconColor,
          size: MediaQuery.of(context).size.shortestSide * .2,
        ),
        Text(S.of(context).MemberDetailsNoDevices),
        SizedBox(height: 5),
        FlatButton(
          child: Text(S.of(context).MemberDetailsNoDevicesAddDevice,style: TextStyle(color: Colors.blue)),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                DeviceOverviewPage(DeviceOverviewBloc(List<Device>())),
            )).then((_)=> _onReload());
          },
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.devices_other,
          color: ApplicationTheme.deviceIconColor,
          size: MediaQuery.of(context).size.shortestSide * .2,
        ),
        Text(S.of(context).MemberDetailsNoDevices),
        SizedBox(height: 5),
        CupertinoButton(
          child: Text(S.of(context).MemberDetailsNoDevicesAddDevice),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                DeviceOverviewPage(DeviceOverviewBloc(List<Device>())),
            )).then((_)=> _onReload());
          },
        ),
      ],
    );
  }
}
