import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';
import 'package:weforza/widgets/custom/dialogs/delete_item_dialog.dart';

class DeleteDeviceDialog extends ConsumerStatefulWidget {
  const DeleteDeviceDialog({super.key, required this.index});

  /// The index of the device that should be deleted.
  final int index;

  @override
  DeleteDeviceDialogState createState() => DeleteDeviceDialogState();
}

class DeleteDeviceDialogState extends ConsumerState<DeleteDeviceDialog> {
  Future<void>? future;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return DeleteItemDialog(
      title: translator.DeleteDevice,
      description: translator.DeleteDeviceDescription,
      errorDescription: translator.GenericError,
      future: future,
      onDeletePressed: () {
        final notifier = ref.read(selectedMemberDevicesProvider.notifier);

        future = notifier.deleteDevice(widget.index).then<void>((_) {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        }).catchError(Future.error);

        setState(() {});
      },
    );
  }
}
