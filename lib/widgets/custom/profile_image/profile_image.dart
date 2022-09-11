import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';

/// This widget represents a profile image.
///
/// The [image] indicates which file should be loaded.
/// If the image could not be loaded, the [personInitials] are displayed instead.
/// If the [personInitials] have not been provided, a placeholder [icon]
/// is displayed instead.
class ProfileImage extends StatelessWidget {
  /// The default constructor.
  const ProfileImage({
    super.key,
    this.backgroundColor,
    required this.icon,
    this.iconColor,
    this.image,
    this.personInitials,
    this.size = 64,
  });

  /// The background color for [icon].
  final Color? backgroundColor;

  /// The icon to use as placeholder if [personInitials] is null or empty.
  final IconData icon;

  /// The color for [icon].
  final Color? iconColor;

  /// The profile image to show.
  final File? image;

  /// The initials of the person.
  final String? personInitials;

  /// The size of this widget.
  ///
  /// Defaults to 64.
  final double size;

  Widget _buildPlaceholder() {
    final initials = personInitials;

    if (initials == null || initials.isEmpty) {
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
        color: _getBackgroundColor(initials),
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

  Color _getBackgroundColor(String initials) {
    int index = initials.codeUnitAt(0);

    if (initials.length == 2) {
      index += initials.codeUnitAt(1);
    }

    return Colors.primaries[index % Colors.primaries.length];
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = _buildPlaceholder();

    if (image == null) {
      return placeholder;
    }

    return Image.file(
      image!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return frame == null ? placeholder : ClipOval(child: child);
      },
    );
  }
}
