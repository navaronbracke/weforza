import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/add_member_model.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';

class AddMemberDelegate {
  AddMemberDelegate(this.repository, this.memberList);

  final MemberListNotifier memberList;

  final MemberRepository repository;

  final _uuidGenerator = const Uuid();

  Future<void> addMember(AddMemberModel model) async {
    final exists = await repository.memberExists(
      model.firstName,
      model.lastName,
      model.alias,
    );

    if (exists) {
      return Future.error(MemberExistsException());
    }

    final image = await model.profileImage.catchError(
      (_) => Future<File?>.value(null),
    );

    final member = Member(
      uuid: _uuidGenerator.v4(),
      firstname: model.firstName,
      lastname: model.lastName,
      alias: model.alias,
      profileImageFilePath: image?.path,
      isActiveMember: true,
      lastUpdated: DateTime.now().toUtc(),
    );

    await repository.addMember(member);

    memberList.getMembers();
  }
}
