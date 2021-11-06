import 'dart:async';

import 'package:weforza/database/memberDao.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberFilterOption.dart';

///This class provides an API to work with members.
class MemberRepository {
  MemberRepository(this._dao);

  ///The internal DAO instance.
  final IMemberDao _dao;

  Future<void> addMember(Member member) => _dao.addMember(member);

  Future<List<Member>> getMembers(MemberFilterOption filter) => _dao.getMembers(filter);

  Future<bool> memberExists(String firstname, String lastname, String alias, [String? uuid]) => _dao.memberExists(firstname, lastname, alias, uuid);

  Future<void> deleteMember(String uuid) => _dao.deleteMember(uuid);

  Future<void> updateMember(Member member) => _dao.updateMember(member);

  Future<int> getAttendingCountForAttendee(String uuid) => _dao.getAttendingCountForAttendee(uuid);

  Future<void> setMemberActive(String uuid, bool value) => _dao.setMemberActive(uuid, value);
}