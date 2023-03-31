import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/device_icon.dart';
import 'package:weforza/widgets/custom/dialogs/delete_device_dialog.dart';
import 'package:weforza/widgets/pages/device_form/device_form.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberDevicesListItem extends StatelessWidget {
  const MemberDevicesListItem({
    super.key,
    required this.device,
    required this.index,
  });

  /// The device that is displayed by this item.
  final Device device;

  /// The index of [device] in the list of devices.
  final int index;

  Widget _buildItem(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: DeviceIcon(type: device.type),
        ),
        Expanded(
          child: Text(
            device.name,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: _EditDeviceButton(device: device),
            ),
            _DeleteDeviceButton(index: index),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.only(left: 8, right: 4, bottom: 4),
        child: _buildItem(context),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
        child: _buildItem(context),
      ),
    );
  }
}

class _DeleteDeviceButton extends ConsumerWidget {
  const _DeleteDeviceButton({required this.index});

  /// The index of the device to delete.
  final int index;

  Future<void> _onDeleteDevicePressed(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(selectedMemberDevicesProvider.notifier);

    return notifier.deleteDevice(index).then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: const Icon(
          Icons.delete,
          color: ApplicationTheme.deleteItemButtonTextColor,
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => DeleteDeviceDialog(
            onDelete: () => _onDeleteDevicePressed(context, ref),
          ),
        ),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: CupertinoIconButton(
          icon: CupertinoIcons.delete,
          idleColor: CupertinoColors.destructiveRed,
          onPressedColor: CupertinoColors.destructiveRed.withAlpha(150),
          onPressed: () => showCupertinoDialog(
            context: context,
            builder: (_) => DeleteDeviceDialog(
              onDelete: () => _onDeleteDevicePressed(context, ref),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditDeviceButton extends ConsumerWidget {
  const _EditDeviceButton({required this.device});

  /// The device to edit.
  final Device device;

  void _onEditDevicePressed(BuildContext context, WidgetRef ref) {
    final selectedMember = ref.read(selectedMemberProvider);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeviceForm(
          device: device,
          ownerUuid: selectedMember!.value.uuid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(
          Icons.edit,
          color: ApplicationTheme.memberDevicesListEditDeviceColor,
        ),
        onPressed: () => _onEditDevicePressed(context, ref),
      ),
      ios: () => CupertinoIconButton.fromAppTheme(
        onPressed: () => _onEditDevicePressed(context, ref),
        icon: CupertinoIcons.pencil,
      ),
    );
  }
}
