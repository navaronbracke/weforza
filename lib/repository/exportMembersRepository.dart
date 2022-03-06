import 'dart:collection';

import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/member_dao.dart';
import 'package:weforza/model/exportable_member.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_filter_option.dart';

class ExportMembersRepository {
  ExportMembersRepository(this.deviceDao, this.memberDao);

  final IDeviceDao deviceDao;
  final IMemberDao memberDao;

  Future<void> _getDevices(HashMap<String, Set<String>> collection) async =>
      collection.addAll(await deviceDao.getAllDevicesGroupedByOwnerId());
  Future<void> _getMembers(List<Member> collection) async =>
      collection.addAll(await memberDao.getMembers(MemberFilterOption.all));

  Future<Iterable<ExportableMember>> getMembers() async {
    final HashMap<String, Set<String>> _devicesGroupedByOwner = HashMap();
    final List<Member> _members = [];

    await Future.wait(
        [_getDevices(_devicesGroupedByOwner), _getMembers(_members)]);

    return _members.map((member) => ExportableMember(
          firstName: member.firstname,
          lastName: member.lastname,
          alias: member.alias,
          isActiveMember: member.isActiveMember,
          devices: _devicesGroupedByOwner[member.uuid] ?? <String>{},
          lastUpdated: member.lastUpdated,
        ));
  }
}
