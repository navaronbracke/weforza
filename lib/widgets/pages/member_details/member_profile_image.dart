import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/custom/profile_image/async_profile_image.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberProfileImage extends ConsumerWidget {
  const MemberProfileImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMember = ref.watch(
      selectedMemberProvider.select((selectedMember) => selectedMember!),
    );

    return PlatformAwareWidget(
      android: () => AsyncProfileImage(
        icon: Icons.person,
        size: 75,
        personInitials: selectedMember.value.initials,
        future: selectedMember.profileImage,
      ),
      ios: () => AsyncProfileImage(
        icon: CupertinoIcons.person_fill,
        size: 75,
        personInitials: selectedMember.value.initials,
        future: selectedMember.profileImage,
      ),
    );
  }
}
