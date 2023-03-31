import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';

/// This widget represents a profile image of a person.
/// If the profile image could not be loaded,
/// the [personInitials] are displayed.
/// If those are null or empty, [icon] is used as a fallback.
class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    this.image,
    this.size = 75,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.personInitials,
  }) : assert(size > 0);

  /// The profile image to show.
  final File? image;

  /// The icon to use as placeholder if [personInitials] is null or empty.
  final IconData icon;

  /// The size of this widget.
  final double size;

  /// The background color for [icon].
  final Color? backgroundColor;

  /// The color for [icon].
  final Color? iconColor;

  /// The initials of the person.
  final String? personInitials;

  Color _getBackgroundColor(String initials) {
    int index = initials.codeUnitAt(0);
    if (initials.length == 2) {
      index += initials.codeUnitAt(1);
    }

    return Colors.primaries[index % Colors.primaries.length];
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      if (personInitials == null || personInitials!.isEmpty) {
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(size / 2)),
            color: backgroundColor,
          ),
          child: Center(child: Icon(icon, color: iconColor, size: .7 * size)),
        );
      }

      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          color: _getBackgroundColor(personInitials!),
        ),
        child: Center(
          child: Text(
            personInitials!.toUpperCase(),
            style: ApplicationTheme.personInitialsTextStyle.copyWith(
              fontSize: .5 * size,
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: Image.file(image!, width: size, height: size, fit: BoxFit.cover),
    );
  }
}
