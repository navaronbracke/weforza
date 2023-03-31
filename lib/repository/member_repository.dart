import 'dart:async';

import 'package:weforza/database/member_dao.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/model/rider/rider.dart';

/// This class provides an API to work with members.
class MemberRepository {
  MemberRepository(this._dao);

  final MemberDao _dao;

  Future<void> addMember(Rider member) => _dao.addMember(member);

  Future<void> deleteMember(String uuid) => _dao.deleteMember(uuid);

  Future<int> getAttendingCount(String uuid) => _dao.getAttendingCount(uuid);

  Future<List<Rider>> getMembers(MemberFilterOption filter) {
    return _dao.getMembers(filter);
  }

  Future<void> setMemberActive(String uuid, {required bool value}) {
    return _dao.setMemberActive(uuid, value: value);
  }

  Future<void> updateMember(Rider member) => _dao.updateMember(member);
}
