import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/device_form.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/delete_device_button.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_empty.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_header.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberDevicesList extends ConsumerStatefulWidget {
  const MemberDevicesList({super.key});

  @override
  MemberDevicesListState createState() => MemberDevicesListState();
}

class MemberDevicesListState extends ConsumerState<MemberDevicesList> {
  void onAddDevicePressed(BuildContext context, String ownerUuid) {
    Navigator.of(context).push<void>(
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
    return SafeArea(
      child: Column(
        children: <Widget>[
          const MemberDevicesListHeader(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final device = devices[index];

                return MemberDevicesListItem(
                  device: device,
                  deleteDeviceButton: DeleteDeviceButton(index: index),
                );
              },
              itemCount: devices.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PlatformAwareWidget(
              android: (context) => TextButton(
                onPressed: () {
                  final selectedMember = ref.read(selectedMemberProvider);

                  onAddDevicePressed(context, selectedMember!.uuid);
                },
                child: Text(S.of(context).AddDevice),
              ),
              ios: (context) => CupertinoButton.filled(
                onPressed: () {
                  final selectedMember = ref.read(selectedMemberProvider);

                  onAddDevicePressed(context, selectedMember!.uuid);
                },
                child: Text(S.of(context).AddDevice),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
