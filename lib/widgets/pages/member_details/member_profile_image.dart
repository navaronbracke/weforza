import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';

class MemberProfileImage extends ConsumerWidget {
  const MemberProfileImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMember = ref.watch(
      selectedMemberProvider.select((selectedMember) => selectedMember!),
    );

    return AdaptiveProfileImage(
      image: selectedMember.profileImage,
      personInitials: selectedMember.value.initials,
      size: 72,
    );
  }
}
