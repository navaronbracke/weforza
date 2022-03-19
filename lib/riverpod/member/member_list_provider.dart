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

  /// The backing list for the data.
  List<Member> _memberList = [];

  /// The search query that filters the members.
  String _searchQuery = '';

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

  /// Filter the given [list] on the current [_searchQuery].
  List<Member> _filterOnSearchQuery(List<Member> list) {
    final effectiveQuery = _searchQuery.trim().toLowerCase();

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

  /// Update the search query with the [newQuery]
  /// and update the list of members.
  void onSearchQueryChanged(String newQuery) {
    if (_searchQuery != newQuery) {
      _searchQuery = newQuery;
    }

    _memberList = _filterOnSearchQuery(_memberList);

    state = Future.value(_memberList);
  }

  /// Get the member list and filter only on the [memberFilter].
  void getMembers() {
    state = memberRepository.getMembers(memberFilter).then((members) {
      _memberList = members;

      return Future.value(_memberList);
    });
  }

  /// Update the member at the given [index] in the list with the new [value].
  void updateMember(Member value, int index) {
    if (_memberList[index] == value) {
      return;
    }

    _memberList[index] = value;

    state = Future.value(_memberList);
  }
}
