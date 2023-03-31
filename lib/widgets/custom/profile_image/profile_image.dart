import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';

///This [Widget] displays a round profile icon or a placeholder if no image is present.
class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
    this.image,
    this.size = 75,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.personInitials,
  })  : assert(size > 0),
        super(key: key);

  ///The image to show.
  final File? image;

  ///The icon to use as placeholder
  final IconData icon;

  ///The width and height of the displayed [Image].
  final double size;

  ///The background color for the placeholder icon's background.
  final Color? backgroundColor;

  ///The icon color for the placeholder icon.
  final Color? iconColor;

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
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: .7 * size,
            ),
          ),
        );
      } else {
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
    }

    return ClipOval(
      child: Image.file(
        image!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
