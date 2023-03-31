import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/pages/device_form/device_form.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the empty member devices list.
class MemberDevicesListEmpty extends StatelessWidget {
  const MemberDevicesListEmpty({super.key});

  void onAddDevicePressed(BuildContext context, String ownerUuid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeviceForm(ownerUuid: ownerUuid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PlatformAwareWidget(
                android: () => Icon(
                  Icons.devices_other,
                  color: ApplicationTheme.listInformationalIconColor,
                  size: size.shortestSide * .1,
                ),
                ios: () => Icon(
                  Icons.devices_other,
                  color: ApplicationTheme.listInformationalIconColor,
                  size: size.shortestSide * .1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Text(
                  translator.MemberDetailsNoDevices,
                  textAlign: TextAlign.center,
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return PlatformAwareWidget(
                    android: () => ElevatedButton(
                      onPressed: () {
                        final selectedMember = ref.read(selectedMemberProvider);

                        onAddDevicePressed(context, selectedMember!.uuid);
                      },
                      child: Text(translator.AddDevice),
                    ),
                    ios: () => CupertinoButton.filled(
                      onPressed: () {
                        final selectedMember = ref.read(selectedMemberProvider);

                        onAddDevicePressed(context, selectedMember!.uuid);
                      },
                      child: Text(
                        translator.AddDevice,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
