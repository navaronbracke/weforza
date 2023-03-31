
import 'package:weforza/database/importMembersDao.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';

class ImportMembersRepository {
  ImportMembersRepository(this.dao): assert(dao != null);

  final IImportMembersDao dao;

  Future<void> saveMembersWithDevices(List<Member> members, List<Device> devices)
    => dao.saveMembersWithDevices(members, devices);
}