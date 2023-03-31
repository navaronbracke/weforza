import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/custom/profile_image/async_profile_image.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberProfileImage extends ConsumerWidget {
  const MemberProfileImage({Key? key}) : super(key: key);

  String _getInitials({
    required String firstName,
    required String lastName,
  }) {
    return firstName[0] + lastName[0];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(
      selectedMemberProvider.select((value) => value!.profileImage),
    );

    final firstName = ref.watch(
      selectedMemberProvider.select((value) => value!.value.firstname),
    );

    final lastName = ref.watch(
      selectedMemberProvider.select((value) => value!.value.lastname),
    );

    return PlatformAwareWidget(
      android: () => AsyncProfileImage(
        icon: Icons.person,
        size: 75,
        personInitials: _getInitials(firstName: firstName, lastName: lastName),
        future: profileImage,
      ),
      ios: () => AsyncProfileImage(
        icon: CupertinoIcons.person_fill,
        size: 75,
        personInitials: _getInitials(firstName: firstName, lastName: lastName),
        future: profileImage,
      ),
    );
  }
}
