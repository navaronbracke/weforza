import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/custom/dialogs/delete_item_dialog.dart';

class DeleteDeviceDialog extends ConsumerStatefulWidget {
  const DeleteDeviceDialog({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

  final Future<void> Function() onDelete;

  @override
  _DeleteDeviceDialogState createState() => _DeleteDeviceDialogState();
}

class _DeleteDeviceDialogState extends ConsumerState<DeleteDeviceDialog> {
  Future<void>? future;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return DeleteItemDialog(
      title: translator.DeleteDeviceTitle,
      description: translator.DeleteDeviceDescription,
      errorDescription: translator.GenericError,
      future: future,
      onDeletePressed: () {
        future = widget.onDelete();

        setState(() {});
      },
    );
  }
}
