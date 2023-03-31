import 'package:flutter/material.dart';

// TODO: fix bug with spaces and italic text

/// This widget displays the first name, alias and last name of a member.
class MemberNameAndAlias extends StatelessWidget {
  const MemberNameAndAlias({
    super.key,
    required this.alias,
    required this.firstName,
    required this.firstLineStyle,
    this.isTwoLine = true,
    required this.lastName,
    this.overflow = TextOverflow.ellipsis,
    required this.secondLineStyle,
  });

  /// The alias to display.
  final String alias;

  /// The style for the text on the first line.
  ///
  /// If [isTwoLine] is true, this is the style for the first name and the alias.
  /// Otherwise this is the style for the first name, alias and last name.
  final TextStyle firstLineStyle;

  /// The first name to display.
  final String firstName;

  /// Whether the first name, alias and last name are displayed on two lines.
  ///
  /// If this is true, the first name and alias are displayed on one line,
  /// followed by the last name on a second line.
  ///
  /// If this is false, the first name, alias and last name are displayed
  /// one after another on a single line.
  final bool isTwoLine;

  /// The last name to display.
  final String lastName;

  /// The overflow for the text.
  final TextOverflow overflow;

  /// The style for the second line.
  ///
  /// If [isTwoLine] is true, this is the style for the last name.
  /// Otherwise this style is ignored.
  final TextStyle secondLineStyle;

  @override
  Widget build(BuildContext context) {
    if (isTwoLine) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: RichText(
              maxLines: 1,
              overflow: overflow,
              text: TextSpan(
                text: firstName,
                style: firstLineStyle,
                children: [
                  if (alias.isNotEmpty)
                    TextSpan(
                      text: " '$alias' ",
                      style: firstLineStyle.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Text(
            lastName,
            maxLines: 1,
            overflow: overflow,
            style: secondLineStyle,
          ),
        ],
      );
    }

    return RichText(
      maxLines: 1,
      overflow: overflow,
      text: alias.isEmpty
          ? TextSpan(text: '$firstName $lastName', style: firstLineStyle)
          : TextSpan(
              text: firstName,
              style: firstLineStyle,
              children: [
                TextSpan(
                  text: " '$alias' ",
                  style: firstLineStyle.copyWith(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: lastName, style: firstLineStyle),
              ],
            ),
    );
  }
}
