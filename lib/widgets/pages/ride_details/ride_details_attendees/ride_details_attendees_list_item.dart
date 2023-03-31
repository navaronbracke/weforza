import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/theme.dart';

class RideDetailsAttendeesListItem extends StatelessWidget {
  RideDetailsAttendeesListItem({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.alias,
  }) : assert(firstName.isNotEmpty && lastName.isNotEmpty);

  final String firstName;
  final String lastName;
  final String alias;

  @override
  Widget build(BuildContext context) {
    const theme = AppTheme.memberListItem;
    final style = theme.lastNameStyle;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: MemberNameAndAlias(
        firstLineStyle: style,
        secondLineStyle: style,
        firstName: firstName,
        lastName: lastName,
        alias: alias,
        isTwoLine: false,
      ),
    );
  }
}
