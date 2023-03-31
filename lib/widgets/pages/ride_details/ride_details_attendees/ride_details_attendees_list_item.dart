import 'package:flutter/widgets.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';

class RideDetailsAttendeesListItem extends StatelessWidget {
  RideDetailsAttendeesListItem({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.alias,
  })  : assert(firstName.isNotEmpty && lastName.isNotEmpty),
        super(key: key);

  final String firstName;
  final String lastName;
  final String alias;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: MemberNameAndAlias(
        firstLineStyle: ApplicationTheme.memberListItemFirstNameTextStyle,
        secondLineStyle: ApplicationTheme.memberListItemLastNameTextStyle,
        firstName: firstName,
        lastName: lastName,
        alias: alias,
        isTwoLine: false,
      ),
    );
  }
}
