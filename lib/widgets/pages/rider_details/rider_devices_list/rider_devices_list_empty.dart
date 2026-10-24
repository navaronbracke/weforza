import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/pages/device_form.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the empty rider devices list.
class RiderDevicesListEmpty extends StatelessWidget {
  const new({super.key});

  void onAddDevicePressed(BuildContext context, WidgetRef ref) {
    final selectedRider = ref.read(selectedRiderProvider);

    if (selectedRider == null) {
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceForm(ownerId: selectedRider.id)));
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisAlignment: .center,
          children: <Widget>[
            PlatformAwareIcon(
              androidIcon: Icons.devices_other,
              iosIcon: Icons.devices_other,
              size: constraints.biggest.shortestSide * .1,
            ),
            Padding(
              padding: const .fromLTRB(16, 8, 16, 32),
              child: Text(translator.riderNoDevices, textAlign: .center),
            ),
            Consumer(
              builder: (context, ref, _) => PlatformAwareWidget(
                android: (context) => ElevatedButton(
                  onPressed: () => onAddDevicePressed(context, ref),
                  child: Text(translator.addDevice),
                ),
                ios: (context) => CupertinoButton.filled(
                  onPressed: () => onAddDevicePressed(context, ref),
                  child: Text(translator.addDevice, style: const TextStyle(color: CupertinoColors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
