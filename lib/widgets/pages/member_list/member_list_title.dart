import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';

/// This widget represents the title in the member list page.
class MemberListTitle extends ConsumerWidget {
  const MemberListTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(memberListProvider);

    return FutureBuilder<List<Member>>(
      future: future,
      builder: (context, snapshot) {
        final translator = S.of(context);

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(translator.Riders);
          }

          return Text(translator.RidersListTitle(snapshot.data?.length ?? 0));
        }

        return Text(translator.Riders);
      },
    );
  }
}
