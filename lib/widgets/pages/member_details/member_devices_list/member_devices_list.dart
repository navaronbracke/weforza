import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_disabled_item.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_empty.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_header.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_item.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberDevicesList extends StatefulWidget {
  const MemberDevicesList({
    Key? key,
    required this.future,
    required this.onDeleteDevice,
    required this.onAddDeviceButtonPressed,
  }) : super(key: key);

  final Future<List<Device>>? future;
  final Future<void> Function(Device device) onDeleteDevice;
  final void Function() onAddDeviceButtonPressed;

  @override
  _MemberDevicesListState createState() => _MemberDevicesListState();
}

class _MemberDevicesListState extends State<MemberDevicesList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Device>>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return GenericError(text: S.of(context).GenericError);
          } else {
            return snapshot.data == null || snapshot.data!.isEmpty
                ? MemberDevicesListEmpty(
                    onAddDevicePageButtonPressed:
                        widget.onAddDeviceButtonPressed,
                  )
                : _buildDevicesList(context, snapshot.data!);
          }
        } else {
          return const Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  Widget _buildDevicesList(BuildContext context, List<Device> devices) {
    return Column(
      children: <Widget>[
        const MemberDevicesListHeader(),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: devices.length,
            itemBuilder: (context, index, animation) => MemberDevicesListItem(
              device: devices[index],
              index: index,
              onDelete: (device, index) =>
                  onDeleteDevice(context, device, index, devices),
            ),
          ),
        ),
        PlatformAwareWidget(
          android: () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextButton(
              onPressed: widget.onAddDeviceButtonPressed,
              child: Text(S.of(context).AddDeviceTitle),
            ),
          ),
          ios: () => Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 15),
            child: CupertinoButton.filled(
              onPressed: widget.onAddDeviceButtonPressed,
              child: Text(
                S.of(context).AddDeviceTitle,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> onDeleteDevice(
      BuildContext context, Device device, int index, List<Device> devices) {
    //delete it from the database
    return widget.onDeleteDevice(device).then((_) {
      Navigator.of(context).pop(); //get rid of the dialog

      final listState = _listKey.currentState;

      if (listState != null) {
        final device = devices.removeAt(index); //remove it from memory
        //and remove it from the animated list
        listState.removeItem(
            index,
            (context, animation) => SizeTransition(
                  sizeFactor: animation,
                  child: MemberDevicesListDisabledItem(device: device),
                ));
        if (devices.isEmpty) {
          setState(() {}); //switch to the is empty list widget
        }
      }
    });
  }
}
