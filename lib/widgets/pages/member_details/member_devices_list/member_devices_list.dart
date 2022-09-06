import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/device_form/device_form.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_disabled_item.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_empty.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_header.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

// TODO: can we eliminate the setState() at the bottom and turn this into a ConsumerWidget?

class MemberDevicesList extends ConsumerStatefulWidget {
  const MemberDevicesList({super.key});

  @override
  MemberDevicesListState createState() => MemberDevicesListState();
}

class MemberDevicesListState extends ConsumerState<MemberDevicesList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  void onAddDevicePressed(BuildContext context, String ownerUuid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeviceForm(ownerUuid: ownerUuid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicesList = ref.watch(selectedMemberDevicesProvider);

    return devicesList.when(
      data: (devices) {
        if (devices.isEmpty) {
          return const MemberDevicesListEmpty();
        }

        return _buildDevicesList(context, devices);
      },
      error: (error, _) => GenericError(text: S.of(context).GenericError),
      loading: () => const Center(child: PlatformAwareLoadingIndicator()),
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
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TextButton(
              onPressed: () {
                final selectedMember = ref.read(selectedMemberProvider);

                onAddDevicePressed(context, selectedMember!.value.uuid);
              },
              child: Text(S.of(context).AddDevice),
            ),
          ),
          ios: () => Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: CupertinoButton.filled(
              onPressed: () {
                final selectedMember = ref.read(selectedMemberProvider);

                onAddDevicePressed(context, selectedMember!.value.uuid);
              },
              child: Text(
                S.of(context).AddDevice,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> onDeleteDevice(BuildContext context, int index) async {
    final device = await ref
        .read(selectedMemberDevicesProvider.notifier)
        .deleteDevice(index);

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

    final devicesList = ref.read(selectedMemberDevicesProvider);

    // Switch to the empty list widget.
    if (devicesList is AsyncData<List<Device>> && devicesList.value.isEmpty) {
      setState(() {});
    }
  }
}
