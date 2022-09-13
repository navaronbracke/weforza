import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_attending_count.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';

class MemberListItem extends ConsumerWidget {
  MemberListItem({
    required this.member,
    required this.onPressed,
  }) : super(key: ValueKey(member.uuid));

  /// The member that is displayed in this item.
  final Member member;

  /// The onTap handler for this item.
  ///
  /// This function is called after the selected member was updated.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final notifier = ref.read(selectedMemberProvider.notifier);

        notifier.setSelectedMember(member);

        onPressed();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: AdaptiveProfileImage.path(
                imagePath: member.profileImageFilePath,
                personInitials: member.initials,
              ),
            ),
            Expanded(
              child: MemberNameAndAlias(
                alias: member.alias,
                firstLineStyle:
                    ApplicationTheme.memberListItemFirstNameTextStyle,
                firstName: member.firstName,
                lastName: member.lastName,
                secondLineStyle:
                    ApplicationTheme.memberListItemLastNameTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: MemberListItemAttendingCount(member: member),
            ),
          ],
        ),
      ),
    );
  }
}
