import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This widget is shown as replacement of a [Member]'s devices, if it has none.
class MemberDevicesListEmpty extends StatelessWidget {
  MemberDevicesListEmpty({@required this.onPressed}): assert(onPressed != null);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Center(
    child: PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    ),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.devices_other,
          color: ApplicationTheme.listInformationalIconColor,
          size: MediaQuery.of(context).size.shortestSide * .1,
        ),
        SizedBox(height: 5),
        Text(S.of(context).MemberDetailsNoDevices),
        SizedBox(height: 5),
        FlatButton(
          child: Text(S.of(context).MemberDetailsNoDevicesAddDevice,style: TextStyle(color: Colors.blue)),
          onPressed: onPressed,
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
          color: ApplicationTheme.listInformationalIconColor,
          size: MediaQuery.of(context).size.shortestSide * .1,
        ),
        SizedBox(height: 5),
        Text(S.of(context).MemberDetailsNoDevices),
        SizedBox(height: 5),
        CupertinoButton(
          child: Text(S.of(context).MemberDetailsNoDevicesAddDevice),
          onPressed: onPressed,
        ),
      ],
    );
  }
}