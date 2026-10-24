import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/pages/device_form.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class AddDeviceButton extends ConsumerWidget {
  const new({super.key});

  void _onAddDevicePressed(BuildContext context, Rider rider) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceForm(ownerId: rider.id)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rider = ref.watch(selectedRiderProvider);

    return PlatformAwareWidget(
      android: (context) => FilledButton(
        onPressed: rider == null ? null : () => _onAddDevicePressed(context, rider),
        child: Text(S.of(context).addDevice),
      ),
      ios: (context) => CupertinoButton.filled(
        onPressed: rider == null ? null : () => _onAddDevicePressed(context, rider),
        child: Text(S.of(context).addDevice, style: const TextStyle(color: CupertinoColors.white)),
      ),
    );
  }
}
