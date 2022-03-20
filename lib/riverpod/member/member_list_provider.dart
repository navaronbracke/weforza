import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';
import 'package:weforza/riverpod/settings_provider.dart';

/// This provider provides the member list notifier.
final memberListProvider =
    StateNotifierProvider<MemberListNotifier, Future<List<Member>>?>((ref) {
  final repository = ref.read(memberRepositoryProvider);
  // Watch the member list filter for changes.
  final filter = ref.watch(
    settingsProvider.select((settings) => settings.memberListFilter),
  );

  return MemberListNotifier(
    memberFilter: filter,
    memberRepository: repository,
  )..getMembers();
});

/// This notifier manages the data for the member list page.
/// It also manages the filter options for that page.
class MemberListNotifier extends StateNotifier<Future<List<Member>>?> {
  MemberListNotifier({
    required this.memberFilter,
    required this.memberRepository,
  }) : super(null);

  /// The repository that loads the members.
  final MemberRepository memberRepository;

  /// The persisted filter for the member list.
  final MemberFilterOption memberFilter;

  /// Returns whether [firstName], [lastName] or [alias]
  /// match the given [query].
  bool _matchesQuery({
    required String alias,
    required String firstName,
    required String lastName,
    required String query,
  }) {
    if (firstName.contains(query) || lastName.contains(query)) {
      return true;
    }

    if (alias.isNotEmpty && alias.contains(query)) {
      return true;
    }

    return false;
  }

  /// Filter the given [list] on the current [searchQuery].
  List<Member> filterOnSearchQuery(List<Member> list, String searchQuery) {
    final effectiveQuery = searchQuery.trim().toLowerCase();

    if (effectiveQuery.isEmpty) {
      return list;
    }

    return list.where((member) {
      final firstName = member.firstname.toLowerCase();
      final lastName = member.lastname.toLowerCase();
      final alias = member.alias.toLowerCase();

      return _matchesQuery(
        alias: alias,
        firstName: firstName,
        lastName: lastName,
        query: effectiveQuery,
      );
    }).toList();
  }

  /// Get the member list and filter only on the [memberFilter].
  void getMembers() {
    state = memberRepository.getMembers(memberFilter);
  }
}
