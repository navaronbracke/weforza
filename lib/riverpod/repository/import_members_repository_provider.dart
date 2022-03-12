import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/import_members_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

/// This provider provides the [ImportMembersRepository].
final importMembersRepositoryProvider = Provider<ImportMembersRepository>(
  (ref) => ImportMembersRepository(ref.read(importMembersDaoProvider)),
);
