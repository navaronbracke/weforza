import 'package:flutter/material.dart';

/// This widget displays the first & last name of a member, combined with the alias in the middle.
class MemberNameAndAlias extends StatelessWidget {
  MemberNameAndAlias({
    required this.firstNameStyle,
    required this.lastNameStyle,
    required this.firstName,
    required this.lastName,
    required this.alias,
    this.isTwoLine = true,
  }): assert(firstName.isNotEmpty && lastName.isNotEmpty);

  final String firstName;
  final String lastName;
  final String alias;
  final TextStyle firstNameStyle;
  final TextStyle lastNameStyle;
  /// Whether to use the two line variant.
  final bool isTwoLine;

  Widget _buildTwoLineVariant(){
    final Widget firstNameAndAlias = alias.isEmpty ? Text(
      firstName,
      style: firstNameStyle,
      overflow: TextOverflow.ellipsis,
    ): Text.rich(
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


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: firstNameAndAlias,
        ),
        Text(lastName, style: lastNameStyle, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildOneLineVariant(){
    return alias.isEmpty ? Text(
        "$firstName $lastName",
        softWrap: true,
        style: lastNameStyle,
        overflow: TextOverflow.ellipsis
    ): Text.rich(
      TextSpan(
          text: firstName,
          style: lastNameStyle,
          children: <InlineSpan>[
            TextSpan(
              text: " '$alias' ",
              style: lastNameStyle.copyWith(
                  fontStyle: FontStyle.italic
              ),
            ),
            TextSpan(
              text: lastName,
              style: lastNameStyle,
            ),
          ]
      ),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context)
    => isTwoLine? _buildTwoLineVariant(): _buildOneLineVariant();
}
