import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/pages/rider_details/rider_devices_list/add_device_button.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';

/// This widget represents the empty rider devices list.
class RiderDevicesListEmpty extends StatelessWidget {
  const new({super.key});

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
            const AddDeviceButton(),
          ],
        ),
      ),
    );
  }
}
