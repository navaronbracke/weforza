import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/member_dao.dart';
import 'package:weforza/model/exportable_member.dart';
import 'package:weforza/model/member_filter_option.dart';

class ExportMembersRepository {
  ExportMembersRepository(this.deviceDao, this.memberDao);

  final DeviceDao deviceDao;
  final IMemberDao memberDao;

  Future<Iterable<ExportableMember>> getMembers() async {
    final membersFuture = memberDao.getMembers(MemberFilterOption.all);
    final devicesFuture = deviceDao.getAllDevicesGroupedByOwnerId();

    final members = await membersFuture;
    final devices = await devicesFuture;

    return members.map(
      (member) => ExportableMember(
        firstName: member.firstname,
        lastName: member.lastname,
        alias: member.alias,
        isActiveMember: member.isActiveMember,
        devices: devices[member.uuid] ?? <String>{},
        lastUpdated: member.lastUpdated,
      ),
    );
  }
}
