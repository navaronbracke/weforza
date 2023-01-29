import 'dart:async';

import 'package:weforza/database/rider_dao.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';

/// This class provides an API to work with members.
class MemberRepository {
  MemberRepository(this._dao);

  final RiderDao _dao;

  Future<void> addMember(Rider rider) => _dao.addRider(rider);

  Future<void> deleteMember(String uuid) => _dao.deleteRider(uuid);

  Future<int> getAttendingCount(String uuid) => _dao.getAttendingCount(uuid);

  Future<List<Rider>> getMembers(RiderFilterOption filter) {
    return _dao.getRiders(filter);
  }

  Future<void> setMemberActive(String uuid, {required bool value}) {
    return _dao.setRiderActive(uuid, value: value);
  }

  Future<void> updateMember(Rider rider) => _dao.updateRider(rider);
}
