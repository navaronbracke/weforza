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
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the member list itself.
class MemberList extends ConsumerWidget {
  const MemberList({
    Key? key,
    required this.onSearchQueryChanged,
    required this.searchQueryStream,
    required this.filter,
  }) : super(key: key);

  final void Function(String query) onSearchQueryChanged;

  final Stream<String> searchQueryStream;

  final List<Member> Function(List<Member> data, String query) filter;

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
            PlatformAwareWidget(
              android: () => TextFormField(
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.disabled,
                onChanged: onSearchQueryChanged,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  labelText: translator.SearchRiders,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
              ios: () => Padding(
                padding: const EdgeInsets.all(8),
                child: CupertinoSearchTextField(
                  suffixIcon: const Icon(CupertinoIcons.search),
                  onChanged: onSearchQueryChanged,
                  placeholder: translator.SearchRiders,
                ),
              ),
            ),
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
