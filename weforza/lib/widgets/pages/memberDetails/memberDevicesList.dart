import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesListItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberDevicesList extends StatelessWidget {
  MemberDevicesList({
    @required this.listKey,
    @required this.devices,
    @required this.onAddButtonPressed,
    @required this.onDeleteDevice,
  }): assert(
    devices != null && onAddButtonPressed != null &&
        onDeleteDevice != null && listKey != null
  );

  final GlobalKey<AnimatedListState> listKey;
  final List<Device> devices;
  final VoidCallback onAddButtonPressed;
  final Future<void> Function(String deviceName, int index) onDeleteDevice;

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
          child: AnimatedList(
            key: listKey,
            initialItemCount: devices.length,
            itemBuilder: (context,index, animation) => MemberDevicesListItem(
              device: devices[index],
              index: index,
              onDelete: onDeleteDevice,
            ),
          ),
        ),
      ],
    );
  }
}
