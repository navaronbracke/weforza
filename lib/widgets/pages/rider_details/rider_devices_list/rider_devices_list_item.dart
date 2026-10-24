import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/common/device_icon.dart';
import 'package:weforza/widgets/pages/device_form.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RiderDevicesListItem extends StatelessWidget {
  const new({required this.deleteDeviceButton, required this.device, super.key});

  /// The button that deletes [device] from the list of devices when pressed.
  final Widget deleteDeviceButton;

  /// The device that is displayed by this item.
  final Device device;

  Widget _buildItem(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const .only(right: 4),
          child: DeviceIcon(type: device.deviceType),
        ),
        Expanded(
          child: Text(
            device.name,
            overflow: .ellipsis,
            softWrap: true,
            maxLines: 2,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const .only(left: 4),
              child: _EditDeviceButton(device: device),
            ),
            deleteDeviceButton,
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) {
        return Padding(padding: const .only(left: 8, right: 4, bottom: 4), child: _buildItem(context));
      },
      ios: (context) => Padding(padding: const .only(left: 4, right: 16), child: _buildItem(context)),
    );
  }
}

class _EditDeviceButton extends ConsumerWidget {
  const new({required this.device});

  /// The device to edit.
  final Device device;

  void _onEditDevicePressed(BuildContext context, Rider rider) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DeviceForm(device: device, ownerId: rider.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rider = ref.watch(selectedRiderProvider);

    return PlatformAwareWidget(
      android: (context) => IconButton(
        icon: Icon(Icons.edit, color: ColorScheme.of(context).primary),
        onPressed: rider == null ? null : () => _onEditDevicePressed(context, rider),
      ),
      ios: (context) => CupertinoIconButton(
        icon: CupertinoIcons.pencil,
        onPressed: rider == null ? null : () => _onEditDevicePressed(context, rider),
      ),
    );
  }
}
