import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget resembles the toggle switch for the 'active' state of a member.
class MemberActiveToggle extends StatelessWidget {
  const MemberActiveToggle({super.key});

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
                selectedMemberProvider.select((m) => m!.active),
              );

              return PlatformAwareWidget(
                android: (_) => Switch(
                  value: isActive,
                  onChanged: (value) {
                    final notifier = ref.read(selectedMemberProvider.notifier);

                    notifier.setMemberActive(value: value);
                  },
                ),
                ios: (_) => CupertinoSwitch(
                  value: isActive,
                  onChanged: (value) {
                    final notifier = ref.read(selectedMemberProvider.notifier);

                    notifier.setMemberActive(value: value);
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
