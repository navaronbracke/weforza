import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/theme.dart';

class RideDetailsAttendeesListItem extends StatelessWidget {
  RideDetailsAttendeesListItem({
    required this.firstName,
    required this.lastName,
    required this.alias,
    super.key,
  }) : assert(
          firstName.isNotEmpty && lastName.isNotEmpty,
          'The first name and last name of a ride attendee should not be empty',
        );

  final String firstName;
  final String lastName;
  final String alias;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: MemberNameAndAlias.singleLine(
        firstName: firstName,
        lastName: lastName,
        alias: alias,
        style: AppTheme.riderTextTheme.lastNameStyle,
      ),
    );
  }
}
