
import 'package:weforza/database/importMembersDao.dart';
import 'package:weforza/model/exportableMember.dart';

class ImportMembersRepository {
  ImportMembersRepository(this.dao);

  final IImportMembersDao dao;

  Future<void> saveMembersWithDevices(Iterable<ExportableMember> members, String Function() generateId)
    => dao.saveMembersWithDevices(members, generateId);
}