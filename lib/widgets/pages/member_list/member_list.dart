import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/common/rider_search_filter_empty.dart';
import 'package:weforza/widgets/pages/member_list/member_list_empty.dart';
import 'package:weforza/widgets/pages/member_list/member_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// This widget represents the member list itself.
class MemberList extends ConsumerWidget {
  const MemberList({
    super.key,
    required this.filter,
    required this.onMemberSelected,
    required this.searchField,
    required this.searchQueryStream,
  });

  /// The function that handles filtering results.
  final List<Member> Function(List<Member> data, String query) filter;

  /// The function that is called after a member is selected.
  final void Function() onMemberSelected;

  /// The widget that provides the search field.
  final Widget searchField;

  /// The stream that provides updates about the search query.
  final Stream<String> searchQueryStream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberList = ref.watch(memberListProvider);
    final translator = S.of(context);

    return memberList.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: MemberListEmpty());
        }

        return Column(
          children: [
            searchField,
            Expanded(
              child: StreamBuilder<String>(
                stream: searchQueryStream,
                builder: (context, snapshot) {
                  final results = filter(items, snapshot.data ?? '');

                  if (results.isEmpty) {
                    return const RiderSearchFilterEmpty();
                  }

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (_, index) => MemberListItem(
                      member: results[index],
                      onPressed: onMemberSelected,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) => GenericError(text: translator.GenericError),
      loading: () => const Center(child: PlatformAwareLoadingIndicator()),
    );
  }
}
