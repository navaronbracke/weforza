import 'dart:async';

import 'package:weforza/database/member_dao.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_filter_option.dart';

/// This class provides an API to work with members.
class MemberRepository {
  MemberRepository(this._dao);

  final MemberDao _dao;

  Future<void> addMember(Member member) => _dao.addMember(member);

  Future<void> deleteMember(String uuid) => _dao.deleteMember(uuid);

  Future<int> getAttendingCount(String uuid) => _dao.getAttendingCount(uuid);

  Future<List<Member>> getMembers(MemberFilterOption filter) {
    return _dao.getMembers(filter);
  }

  Future<bool> memberExists(
    String firstname,
    String lastname,
    String alias, [
    String? uuid,
  ]) {
    return _dao.memberExists(firstname, lastname, alias, uuid);
  }

  Future<void> setMemberActive(String uuid, bool value) {
    return _dao.setMemberActive(uuid, value);
  }

  Future<void> updateMember(Member member) => _dao.updateMember(member);
}
