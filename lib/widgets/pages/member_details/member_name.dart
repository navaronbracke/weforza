import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/theme/app_theme.dart';

class MemberName extends ConsumerWidget {
  const MemberName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(
      selectedMemberProvider.select((value) => value!.value.firstname),
    );

    final lastName = ref.watch(
      selectedMemberProvider.select((value) => value!.value.lastname),
    );

    final alias = ref.watch(
      selectedMemberProvider.select((value) => value!.value.alias),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          firstName,
          style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          lastName,
          style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(
            fontSize: 20,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (alias.isNotEmpty)
          Text(
            "'$alias'",
            style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
