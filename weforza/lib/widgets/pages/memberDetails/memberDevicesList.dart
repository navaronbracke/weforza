import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesListItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberDevicesList extends StatelessWidget {
  MemberDevicesList({
    @required this.devices,
    @required this.onAddButtonPressed
  }): assert(devices != null && onAddButtonPressed != null);

  final List<Device> devices;
  final VoidCallback onAddButtonPressed;

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                    S.of(context).DevicesListHeader,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                ),
              ),
            ),
            PlatformAwareWidget(
              android: () => IconButton(
                icon: Icon(
                    Icons.add,
                    color: ApplicationTheme.memberDevicesListHeaderAddDeviceButtonColor
                ),
                onPressed: onAddButtonPressed,
              ),
              ios: () => CupertinoIconButton(
                onPressedColor: ApplicationTheme.memberDevicesListHeaderAddDeviceButtonPressedColor,
                idleColor: ApplicationTheme.memberDevicesListHeaderAddDeviceButtonIdleColor,
                icon: Icons.add,
                onPressed: onAddButtonPressed,
              ),
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemBuilder: (context,index) => MemberDevicesListItem(
                device: devices[index]
              ),
              itemCount: devices.length
          ),
        ),
      ],
    );
  }
}
