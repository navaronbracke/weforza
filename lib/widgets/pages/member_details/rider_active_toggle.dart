import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget resembles the toggle switch for the 'active' state of a rider.
class RiderActiveToggle extends StatelessWidget {
  const RiderActiveToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(S.of(context).Active),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Consumer(
            builder: (_, ref, child) {
              final isActive = ref.watch(
                selectedRiderProvider.select((r) => r!.active),
              );

              return PlatformAwareWidget(
                android: (_) => Switch(
                  value: isActive,
                  onChanged: (value) {
                    final notifier = ref.read(selectedRiderProvider.notifier);

                    notifier.setRiderActive(value: value);
                  },
                ),
                ios: (_) => CupertinoSwitch(
                  value: isActive,
                  onChanged: (value) {
                    final notifier = ref.read(selectedRiderProvider.notifier);

                    notifier.setRiderActive(value: value);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
