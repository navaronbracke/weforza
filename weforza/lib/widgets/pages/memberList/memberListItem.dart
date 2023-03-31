import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/memberAttendingCount.dart';
import 'package:weforza/widgets/common/memberNameAndAlias.dart';
import 'package:weforza/widgets/custom/profileImage/asyncProfileImage.dart';

class MemberListItem extends StatelessWidget {
  MemberListItem({
    @required this.member,
    @required this.memberAttendingCount,
    @required this.memberProfileImage,
    @required this.onTap
  }): assert(
    member != null && memberProfileImage != null &&
        memberAttendingCount != null && onTap != null
  );

  final Member member;
  final Future<int> memberAttendingCount;
  final Future<File> memberProfileImage;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: AsyncProfileImage(
                  icon: Icons.person,
                  personInitials: member.initials,
                  future: memberProfileImage,
                ),
              ),
              Expanded(
                child: MemberNameAndAlias(
                  firstNameStyle: ApplicationTheme.memberListItemFirstNameTextStyle,
                  lastNameStyle: ApplicationTheme.memberListItemLastNameTextStyle,
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
