import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';

/// This widget represents the title in the member list page.
class MemberListTitle extends ConsumerWidget {
  const MemberListTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberList = ref.watch(memberListProvider);
    final translator = S.of(context);

    return memberList.when(
      data: (items) => Text(translator.RidersListTitle(items.length)),
      error: (error, stackTrace) => Text(translator.Riders),
      loading: () => Text(translator.Riders),
    );
  }
}
