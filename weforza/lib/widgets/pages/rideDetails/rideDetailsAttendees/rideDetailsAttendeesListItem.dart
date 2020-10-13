import 'package:flutter/widgets.dart';

class RideDetailsAttendeesListItem extends StatelessWidget {
  RideDetailsAttendeesListItem({
    @required this.firstName,
    @required this.lastName,
    @required this.alias,
    this.textStyle
  }): assert(
  firstName != null && firstName.isNotEmpty && lastName != null
      && lastName.isNotEmpty && alias != null
  );

  final String firstName;
  final String lastName;
  final String alias;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: alias.isEmpty ? Text(
          "$firstName $lastName",
          softWrap: true,
          style: textStyle,
          overflow: TextOverflow.ellipsis
      ): Text.rich(
        TextSpan(
            text: firstName,
            style: textStyle,
            children: <InlineSpan>[
              TextSpan(
                text: " '$alias' ",
                style: textStyle.copyWith(fontStyle: FontStyle.italic),
              ),
              TextSpan(
                text: lastName,
                style: textStyle,
              ),
            ]
        ),
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
