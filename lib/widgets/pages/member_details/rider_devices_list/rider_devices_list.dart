import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device/device.dart';
import 'package:weforza/riverpod/rider/selected_rider_devices_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/device_form.dart';
import 'package:weforza/widgets/pages/member_details/rider_devices_list/delete_device_button.dart';
import 'package:weforza/widgets/pages/member_details/rider_devices_list/rider_devices_list_empty.dart';
import 'package:weforza/widgets/pages/member_details/rider_devices_list/rider_devices_list_header.dart';
import 'package:weforza/widgets/pages/member_details/rider_devices_list/rider_devices_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RiderDevicesList extends ConsumerStatefulWidget {
  const RiderDevicesList({super.key});

  @override
  ConsumerState<RiderDevicesList> createState() => _RiderDevicesListState();
}

class _RiderDevicesListState extends ConsumerState<RiderDevicesList> {
  void onAddDevicePressed(BuildContext context, String ownerUuid) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => DeviceForm(ownerUuid: ownerUuid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicesList = ref.watch(selectedRiderDevicesProvider);

    return devicesList.when(
      data: (devices) {
        if (devices.isEmpty) {
          return const RiderDevicesListEmpty();
        }

        return _buildDevicesList(context, devices);
      },
      error: (error, _) => const Center(child: GenericError()),
      loading: () => const Center(child: PlatformAwareLoadingIndicator()),
    );
  }

  Widget _buildDevicesList(BuildContext context, List<Device> devices) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          const RiderDevicesListHeader(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final device = devices[index];

                return RiderDevicesListItem(
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
                  final selectedRider = ref.read(selectedRiderProvider);

                  onAddDevicePressed(context, selectedRider!.uuid);
                },
                child: Text(S.of(context).AddDevice),
              ),
              ios: (context) => CupertinoButton.filled(
                onPressed: () {
                  final selectedRider = ref.read(selectedRiderProvider);

                  onAddDevicePressed(context, selectedRider!.uuid);
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
