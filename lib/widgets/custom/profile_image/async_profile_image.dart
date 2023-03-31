import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';

/// This widget asynchronously loads and displays a given profile image.
/// When the image could not be loaded, the [personInitials] are displayed.
/// If the [personInitials] have not been provided,
/// the [icon] is displayed instead.
class AsyncProfileImage extends StatelessWidget {
  const AsyncProfileImage({
    super.key,
    required this.future,
    required this.icon,
    this.personInitials,
    this.size = 40,
  });

  /// The future that represents the loading of the image.
  final Future<File?> future;

  /// The icon that is used as fallback if [personInitials] is null or empty.
  final IconData icon;

  /// The person's initials that are used as placeholder
  /// when the image is unavailable.
  final String? personInitials;

  /// The size of this widget.
  ///
  /// Defaults to 40.
  final double size;

  @override
  Widget build(BuildContext context) {
    final bgColor = ApplicationTheme.profileImagePlaceholderIconBackgroundColor;

    return FutureBuilder<File?>(
      future: future,
      builder: (context, snapshot) => ProfileImage(
        backgroundColor: bgColor,
        icon: icon,
        iconColor: ApplicationTheme.profileImagePlaceholderIconColor,
        image: snapshot.data,
        personInitials: personInitials,
        size: size,
      ),
    );
  }
}
