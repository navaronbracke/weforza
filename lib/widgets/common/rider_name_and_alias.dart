import 'package:flutter/material.dart';

/// This widget displays the first name, alias and last name of a rider.
class RiderNameAndAlias extends StatelessWidget {
  const RiderNameAndAlias.singleLine({
    required this.alias,
    required this.firstName,
    required this.lastName,
    required TextStyle style,
    super.key,
    this.overflow = TextOverflow.ellipsis,
  }) : _isTwoLine = false,
       firstLineStyle = style,
       secondLineStyle = null;

  const RiderNameAndAlias.twoLines({
    required this.alias,
    required this.firstLineStyle,
    required this.firstName,
    required this.lastName,
    required this.secondLineStyle,
    super.key,
    this.overflow = TextOverflow.ellipsis,
  }) : _isTwoLine = true;

  /// The alias to display.
  final String alias;

  /// The style for the text on the first line.
  ///
  /// If the name of the rider is displayed on a single line,
  /// this is the style for the text.
  ///
  /// If the name of the rider is displayed on two lines,
  /// this is the style for the first name and the alias,
  /// which are displayed on the first line.
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
  final bool _isTwoLine;

  /// The last name to display.
  final String lastName;

  /// The overflow for the text.
  final TextOverflow overflow;

  /// The style for the second line.
  final TextStyle? secondLineStyle;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final effectiveFirstLineStyle = defaultStyle.merge(firstLineStyle);

    if (_isTwoLine) {
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
                style: effectiveFirstLineStyle,
                children: [
                  if (alias.isNotEmpty)
                    TextSpan(text: " '$alias' ", style: effectiveFirstLineStyle.copyWith(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          Text(lastName, maxLines: 1, overflow: overflow, style: defaultStyle.merge(secondLineStyle)),
        ],
      );
    }

    return RichText(
      maxLines: 1,
      overflow: overflow,
      text:
          alias.isEmpty
              ? TextSpan(text: '$firstName $lastName', style: effectiveFirstLineStyle)
              : TextSpan(
                text: firstName,
                style: effectiveFirstLineStyle,
                children: [
                  TextSpan(text: " '$alias' ", style: effectiveFirstLineStyle.copyWith(fontStyle: FontStyle.italic)),
                  TextSpan(text: lastName, style: effectiveFirstLineStyle),
                ],
              ),
    );
  }
}
