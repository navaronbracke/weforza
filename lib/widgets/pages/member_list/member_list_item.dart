import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_attending_count.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/custom/profile_image/async_profile_image.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberListItem extends ConsumerStatefulWidget {
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
  MemberListItemState createState() => MemberListItemState();
}

class MemberListItemState extends ConsumerState<MemberListItem> {
  late final Future<int> memberAttendingCount;
  late final Future<File?> memberProfileImage;

  void getProfileImageAndAttendingCount(
    IFileHandler fileHander,
    MemberRepository memberRepository,
  ) {
    memberProfileImage = fileHander.loadProfileImageFromDisk(
      widget.member.profileImageFilePath,
    );

    memberAttendingCount = memberRepository.getAttendingCountForAttendee(
      widget.member.uuid,
    );
  }

  @override
  void initState() {
    super.initState();
    getProfileImageAndAttendingCount(
      ref.read(fileHandlerProvider),
      ref.read(memberRepositoryProvider),
    );
  }

  Widget _buildName() {
    return MemberNameAndAlias(
      firstLineStyle: ApplicationTheme.memberListItemFirstNameTextStyle,
      secondLineStyle: ApplicationTheme.memberListItemLastNameTextStyle,
      firstName: widget.member.firstname,
      lastName: widget.member.lastname,
      alias: widget.member.alias,
    );
  }

  Widget _buildProfileImage() {
    return PlatformAwareWidget(
      android: () => AsyncProfileImage(
        icon: Icons.person,
        personInitials: widget.member.initials,
        future: memberProfileImage,
      ),
      ios: () => AsyncProfileImage(
        icon: CupertinoIcons.person_fill,
        personInitials: widget.member.initials,
        future: memberProfileImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final notifier = ref.read(selectedMemberProvider.notifier);

        notifier.setSelectedMember(
          attendingCount: memberAttendingCount,
          member: widget.member,
          profileImage: memberProfileImage,
        );

        widget.onPressed();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _buildProfileImage(),
            ),
            Expanded(child: _buildName()),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: MemberAttendingCount(future: memberAttendingCount),
            ),
          ],
        ),
      ),
    );
  }
}
