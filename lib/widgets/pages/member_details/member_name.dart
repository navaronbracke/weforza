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

    const textTheme = AppTheme.riderTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          firstName,
          style: textTheme.firstNameLargeStyle,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          lastName,
          style: textTheme.lastNameLargeStyle,
          overflow: TextOverflow.ellipsis,
        ),
        if (alias.isNotEmpty)
          Text(
            "'$alias'",
            style: textTheme.aliasStyle,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
