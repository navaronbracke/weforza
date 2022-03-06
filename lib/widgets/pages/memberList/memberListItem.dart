import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_attending_count.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/custom/profile_image/async_profile_image.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberListItem extends StatelessWidget {
  const MemberListItem({
    Key? key,
    required this.member,
    required this.memberAttendingCount,
    required this.memberProfileImage,
    required this.onTap,
  }) : super(key: key);

  final Member member;
  final Future<int> memberAttendingCount;
  final Future<File?> memberProfileImage;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: PlatformAwareWidget(
                  android: () => AsyncProfileImage(
                    icon: Icons.person,
                    personInitials: member.initials,
                    future: memberProfileImage,
                  ),
                  ios: () => AsyncProfileImage(
                    icon: CupertinoIcons.person_fill,
                    personInitials: member.initials,
                    future: memberProfileImage,
                  ),
                ),
              ),
              Expanded(
                child: MemberNameAndAlias(
                  firstNameStyle:
                      ApplicationTheme.memberListItemFirstNameTextStyle,
                  lastNameStyle:
                      ApplicationTheme.memberListItemLastNameTextStyle,
                  firstName: member.firstname,
                  lastName: member.lastname,
                  alias: member.alias,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: MemberAttendingCount(
                  future: memberAttendingCount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
