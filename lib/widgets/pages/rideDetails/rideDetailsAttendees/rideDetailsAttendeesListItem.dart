import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/memberNameAndAlias.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: MemberNameAndAlias(
        firstNameStyle: ApplicationTheme.memberListItemFirstNameTextStyle,
        lastNameStyle: ApplicationTheme.memberListItemLastNameTextStyle,
        firstName: firstName,
        lastName: lastName,
        alias: alias,
        isTwoLine: false,
      ),
    );
  }
}
