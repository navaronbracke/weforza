import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This widget is shown as replacement of a [Member]'s devices, if it has none.
class MemberDevicesEmpty extends StatelessWidget implements PlatformAwareWidget {
  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
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
            //TODO go to manage devices screen
          },
        ),
      ],
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
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
            //TODO go to manage devices screen
          },
        ),
      ],
    );
  }


}
