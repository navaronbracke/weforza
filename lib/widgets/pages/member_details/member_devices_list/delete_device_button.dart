import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/dialogs/delete_device_dialog.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class DeleteDeviceButton extends StatelessWidget {
  const DeleteDeviceButton({super.key, required this.index});

  /// The index of the device to delete.
  final int index;

  void _onDeletePressed(BuildContext context) async {
    await showWeforzaDialog<void>(
      context,
      builder: (_) => DeleteDeviceDialog(index: index),
    );
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
