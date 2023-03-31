import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/export_members_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

/// This provider provides the [ExportMembersRepository].
final exportMembersRepositoryProvider = Provider<ExportMembersRepository>(
  (ref) => ExportMembersRepository(
    ref.read(deviceDaoProvider),
    ref.read(memberDaoProvider),
  ),
);
