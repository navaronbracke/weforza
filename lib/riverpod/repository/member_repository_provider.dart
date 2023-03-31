import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/riverpod/database/database_dao_provider.dart';

/// This provider provides the [MemberRepository].
final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepository(ref.read(memberDaoProvider));
});
