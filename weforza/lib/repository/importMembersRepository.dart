
import 'package:weforza/database/importMembersDao.dart';

class ImportMembersRepository {
  ImportMembersRepository(this.dao): assert(dao != null);

  final IImportMembersDao dao;

  Future<void> saveMembersWithDevices(List<Map<String,dynamic>> membersWithDevicesData)
    => dao.saveMembersWithDevices(membersWithDevicesData);
}