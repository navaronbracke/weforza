
import 'dart:collection';

import 'package:weforza/database/deviceDao.dart';
import 'package:weforza/database/memberDao.dart';
import 'package:weforza/model/exportableMember.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberFilterOption.dart';

class ExportMembersRepository {
  ExportMembersRepository(this.deviceDao, this.memberDao):
        assert(deviceDao != null && memberDao != null);

  final IDeviceDao deviceDao;
  final IMemberDao memberDao;

  Future<void> _getDevices(HashMap<String,Set<String>> collection) async => collection.addAll(await deviceDao.getAllDevicesGroupedByOwnerId());
  Future<void> _getMembers(List<Member> collection) async => collection.addAll(await memberDao.getMembers(MemberFilterOption.ALL));

  Future<Iterable<ExportableMember>> getMembers() async {
    final HashMap<String,Set<String>> _devicesGroupedByOwner = HashMap();
    final List<Member> _members = [];

    await Future.wait([
      _getDevices(_devicesGroupedByOwner),
      _getMembers(_members)
    ]);

    return _members.map((member) => ExportableMember(
        firstName: member.firstname,
        lastName: member.lastname,
        alias: member.alias,
        isActiveMember: member.isActiveMember,
        devices: _devicesGroupedByOwner[member.uuid] ?? Set<String>()
    ));
  }
}