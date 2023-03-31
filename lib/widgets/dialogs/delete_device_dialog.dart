import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';
import 'package:weforza/widgets/dialogs/delete_item_dialog.dart';

class DeleteDeviceDialog extends ConsumerStatefulWidget {
  const DeleteDeviceDialog({super.key, required this.index});

  /// The index of the device that should be deleted.
  final int index;

  @override
  ConsumerState<DeleteDeviceDialog> createState() => _DeleteDeviceDialogState();
}

class _DeleteDeviceDialogState extends ConsumerState<DeleteDeviceDialog> {
  Future<void>? future;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return DeleteItemDialog(
      description: translator.DeleteDeviceDescription,
      errorDescription: translator.DeleteDeviceErrorDescription,
      future: future,
      onDeletePressed: () {
        final notifier = ref.read(selectedMemberDevicesProvider.notifier);

        future = notifier.deleteDevice(widget.index).then((_) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });

        setState(() {});
      },
      pendingDescription: translator.DeleteDevicePendingDescription,
      title: translator.DeleteDevice,
    );
  }
}
