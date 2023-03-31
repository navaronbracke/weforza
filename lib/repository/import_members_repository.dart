import 'package:weforza/database/import_members_dao.dart';
import 'package:weforza/model/exportable_member.dart';

class ImportMembersRepository {
  ImportMembersRepository(this.dao);

  final IImportMembersDao dao;

  Future<void> saveMembersWithDevices(
          Iterable<ExportableMember> members, String Function() generateId) =>
      dao.saveMembersWithDevices(members, generateId);
}
