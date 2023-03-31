import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/dialogs/delete_device_dialog.dart';
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

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: const Icon(
          Icons.delete,
          color: ApplicationTheme.deleteItemButtonTextColor,
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
      ios: () => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: CupertinoIconButton(
          icon: CupertinoIcons.delete,
          idleColor: CupertinoColors.destructiveRed,
          onPressedColor: CupertinoColors.destructiveRed.withAlpha(150),
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
      ),
    );
  }
}
