import 'package:flutter/material.dart';

/// This widget displays the first & last name of a member, combined with the alias in the middle.
class MemberNameAndAlias extends StatelessWidget {
  MemberNameAndAlias({
    @required this.firstNameStyle,
    @required this.lastNameStyle,
    @required this.firstName,
    @required this.lastName,
    @required this.alias
  }): assert(
  firstNameStyle != null && lastNameStyle != null && firstName != null &&
      firstName.isNotEmpty && lastName != null && lastName.isNotEmpty
      && alias != null
  );

  final String firstName;
  final String lastName;
  final String alias;
  final TextStyle firstNameStyle;
  final TextStyle lastNameStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _combineFirstNameAndAlias(),
        ),
        Text(lastName, style: lastNameStyle, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  // Combine the first name with the alias.
  Widget _combineFirstNameAndAlias(){
    if(alias.isEmpty){
      return Text(
        firstName,
        style: firstNameStyle,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text.rich(
      TextSpan(
          text: firstName,
          style: firstNameStyle,
          children: [
            TextSpan(
              text: " '$alias'",
              style: firstNameStyle.copyWith(fontStyle: FontStyle.italic),
            ),
          ]
      ),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}
