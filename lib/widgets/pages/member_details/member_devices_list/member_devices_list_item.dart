import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/riverpod/device/selected_device_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/device_widget_utils.dart';
import 'package:weforza/widgets/custom/dialogs/delete_device_dialog.dart';
import 'package:weforza/widgets/pages/edit_device/edit_device_page.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberDevicesListItem extends ConsumerStatefulWidget {
  const MemberDevicesListItem({
    Key? key,
    required this.device,
    required this.onDelete,
  }) : super(key: key);

  /// The initially selected device.
  final Device device;

  /// The function that handles deleting the device.
  final Future<void> Function() onDelete;

  @override
  _MemberDevicesListItemState createState() => _MemberDevicesListItemState();
}

class _MemberDevicesListItemState extends ConsumerState<MemberDevicesListItem> {
  /// The mutable variant of the device.
  /// This object is updated whenever the device is edited.
  late Device device;

  void _onEditDevicePressed(BuildContext context) async {
    ref.read(selectedDeviceProvider.notifier).state = device;

    final updatedDevice = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EditDevicePage()),
    );

    if (!mounted || updatedDevice == null) {
      return;
    }

    setState(() {
      device = updatedDevice;
    });
  }

  @override
  void initState() {
    super.initState();
    device = widget.device;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 5, 5),
        child: _buildItem(context),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.fromLTRB(5, 15, 15, 15),
        child: _buildItem(context),
      ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: getDeviceIcon(device.type),
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
              padding: const EdgeInsets.only(left: 5),
              child: _buildEditDeviceButton(context),
            ),
            _buildDeleteDeviceButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildEditDeviceButton(BuildContext context) {
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(
          Icons.edit,
          color: ApplicationTheme.memberDevicesListEditDeviceColor,
        ),
        onPressed: () => _onEditDevicePressed(context),
      ),
      ios: () => CupertinoIconButton.fromAppTheme(
        onPressed: () => _onEditDevicePressed(context),
        icon: CupertinoIcons.pencil,
      ),
    );
  }

  Widget _buildDeleteDeviceButton(BuildContext context) {
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: const Icon(
          Icons.delete,
          color: ApplicationTheme.deleteItemButtonTextColor,
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => DeleteDeviceDialog(onDelete: widget.onDelete),
        ),
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(left: 5),
        child: CupertinoIconButton(
          icon: CupertinoIcons.delete,
          idleColor: CupertinoColors.destructiveRed,
          onPressedColor: CupertinoColors.destructiveRed.withAlpha(150),
          onPressed: () => showCupertinoDialog(
            context: context,
            builder: (_) => DeleteDeviceDialog(onDelete: widget.onDelete),
          ),
        ),
      ),
    );
  }
}
