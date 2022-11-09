import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/dialogs/delete_device_dialog.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class DeleteDeviceButton extends StatelessWidget {
  const DeleteDeviceButton({
    super.key,
    required this.index,
    required this.onDeviceDeleted,
  });

  /// The index of the device to delete.
  final int index;

  /// The handler that is invoked after a device was deleted.
  final void Function() onDeviceDeleted;

  void _onDeletePressed(BuildContext context) async {
    final result = await showWeforzaDialog<bool>(
      context,
      builder: (_) => DeleteDeviceDialog(index: index),
    );

    if (result ?? false) {
      onDeviceDeleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) => IconButton(
        icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
        onPressed: () => _onDeletePressed(context),
      ),
      ios: (context) => CupertinoIconButton(
        color: CupertinoColors.systemRed,
        icon: CupertinoIcons.delete,
        onPressed: () => _onDeletePressed(context),
      ),
    );
  }
}
