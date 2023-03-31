import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/custom/dialogs/delete_device_dialog.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(
          Icons.delete,
          color: AppTheme.desctructiveAction.androidErrorStyle.color,
        ),
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => DeleteDeviceDialog(index: index),
          );

          if (result ?? false) {
            onDeviceDeleted();
          }
        },
      ),
      ios: () => CupertinoIconButton(
        color: CupertinoColors.systemRed,
        icon: CupertinoIcons.delete,
        onPressed: () async {
          final result = await showCupertinoDialog<bool>(
            context: context,
            builder: (_) => DeleteDeviceDialog(index: index),
          );

          if (result ?? false) {
            onDeviceDeleted();
          }
        },
      ),
    );
  }
}
