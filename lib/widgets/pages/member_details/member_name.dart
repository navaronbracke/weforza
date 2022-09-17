import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/theme.dart';

class MemberName extends ConsumerWidget {
  const MemberName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(
      selectedMemberProvider.select((value) => value!.firstName),
    );

    final lastName = ref.watch(
      selectedMemberProvider.select((value) => value!.lastName),
    );

    final alias = ref.watch(
      selectedMemberProvider.select((value) => value!.alias),
    );

    const theme = AppTheme.memberListItem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          firstName,
          style: theme.firstNameStyle.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          lastName,
          style: theme.lastNameStyle.copyWith(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        if (alias.isNotEmpty)
          Text(
            "'$alias'",
            style: theme.lastNameStyle.copyWith(
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
