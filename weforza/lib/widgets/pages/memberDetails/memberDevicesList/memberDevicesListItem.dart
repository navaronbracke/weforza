
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/deviceWidgetUtils.dart';
import 'package:weforza/widgets/custom/deleteItemDialog/deleteItemDialog.dart';
import 'package:weforza/widgets/pages/editDevice/editDevicePage.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class MemberDevicesListItem extends StatefulWidget {
  MemberDevicesListItem({
    required this.device,
    required this.onDelete,
    required this.index,
  });

  //Initial value from the list builder
  final Device device;
  final int index;
  final Future<void> Function(Device device, int index) onDelete;

  @override
  _MemberDevicesListItemState createState() => _MemberDevicesListItemState();
}

class _MemberDevicesListItemState extends State<MemberDevicesListItem> {
  //Device field that can be updated when the device is edited.
  late Device device;

  @override
  void initState(){
    super.initState();
    //Set the initial data
    device = widget.device;
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => Padding(
      padding: const EdgeInsets.fromLTRB(10,0,5,5),
      child: _buildItem(context),
    ),
    ios: () => Padding(
      padding: const EdgeInsets.fromLTRB(5, 15, 15, 15),
      child: _buildItem(context),
    ),
  );

  Widget _buildItem(BuildContext context){
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: getDeviceIcon(device.type),
        ),
        Expanded(
          child: Text(
            device.name,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: _buildEditDeviceButton(context),
            ),
            _buildDeleteDeviceButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildEditDeviceButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(
            Icons.edit,
            color: ApplicationTheme.memberDevicesListEditDeviceColor,
        ),
        onPressed: (){
          SelectedItemProvider.of(context).selectedDevice.value = device;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditDevicePage())).then((editedDevice){
            if(editedDevice != null){
              setState(() {
                device = editedDevice;
              });
            }
          });
        },
      ),
      ios: () => CupertinoIconButton.fromAppTheme(
        onPressed: (){
          SelectedItemProvider.of(context).selectedDevice.value = device;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditDevicePage())).then((editedDevice){
            if(editedDevice != null){
              setState(() {
                device = editedDevice;
              });
            }
          });
        },
        icon: CupertinoIcons.pencil,
      ),
    );
  }

  Widget _buildDeleteDeviceButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(
          Icons.delete,
          color: ApplicationTheme.deleteItemButtonTextColor,
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => DeleteItemDialog(
            title: S.of(context).DeleteDeviceTitle,
            description: S.of(context).DeleteDeviceDescription,
            errorDescription: S.of(context).GenericError,
            onDelete: () => widget.onDelete(device, widget.index),
          ),
        ),
      ),
      ios: () => CupertinoIconButton(
        icon: CupertinoIcons.delete,
        idleColor: ApplicationTheme.deleteItemButtonTextColor,
        onPressedColor: ApplicationTheme.deleteItemButtonTextColor.withAlpha(150),
        onPressed: () => showCupertinoDialog(
          context: context,
          builder: (_) => DeleteItemDialog(
            title: S.of(context).DeleteDeviceTitle,
            description: S.of(context).DeleteDeviceDescription,
            errorDescription: S.of(context).GenericError,
            onDelete: () => widget.onDelete(device, widget.index),
          ),
        ),
      ),
    );
  }
}

