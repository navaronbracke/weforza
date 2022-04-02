import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/add_device/add_device_page.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_disabled_item.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_empty.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_header.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberDevicesList extends ConsumerStatefulWidget {
  const MemberDevicesList({
    Key? key,
  }) : super(key: key);

  @override
  _MemberDevicesListState createState() => _MemberDevicesListState();
}

class _MemberDevicesListState extends ConsumerState<MemberDevicesList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  late final SelectedMemberNotifier selectedMemberNotifier;

  void onAddDevicePressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddDevicePage()),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedMemberNotifier = ref.read(selectedMemberProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final future = ref.watch(
      selectedMemberProvider.select((value) => value?.devices),
    );

    return FutureBuilder<List<Device>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return GenericError(text: S.of(context).GenericError);
            }

            final data = snapshot.data ?? [];

            if (data.isEmpty) {
              return const MemberDevicesListEmpty();
            }

            return _buildDevicesList(context, data);
          default:
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
              onDelete: () => onDeleteDevice(context, index),
            ),
          ),
        ),
        PlatformAwareWidget(
          android: () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextButton(
              onPressed: () => onAddDevicePressed(context),
              child: Text(S.of(context).AddDeviceTitle),
            ),
          ),
          ios: () => Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 15),
            child: CupertinoButton.filled(
              onPressed: () => onAddDevicePressed(context),
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

  Future<void> onDeleteDevice(BuildContext context, int index) async {
    final device = await selectedMemberNotifier.deleteDevice(index);

    if (!mounted) {
      return;
    }

    // Get rid of the delete dialog.
    Navigator.of(context).pop();

    final listState = _listKey.currentState;

    if (listState == null) {
      return;
    }

    // Remove the device from the animated list.
    listState.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: MemberDevicesListDisabledItem(device: device),
      ),
    );

    // Switch to the empty list widget.
    if (selectedMemberNotifier.hasNoDevices) {
      setState(() {});
    }
  }
}
