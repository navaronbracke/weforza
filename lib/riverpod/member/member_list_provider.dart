import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weforza/model/member.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';
import 'package:weforza/riverpod/settings_provider.dart';

/// This provider provides the list of members.
final memberListProvider = FutureProvider<List<Member>>((ref) async {
  final repository = ref.read(memberRepositoryProvider);

  // Watch the member list filter for changes.
  final filter = await ref.watch(
    settingsProvider.selectAsync((settings) => settings.memberListFilter),
  );

  return repository.getMembers(filter);
});
