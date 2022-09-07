import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// This widget asynchronously loads a given profile image.
/// When the image could not be loaded, the given initials are displayed.
class AsyncProfileImage extends StatelessWidget {
  const AsyncProfileImage({
    Key? key,
    this.personInitials,
    required this.icon,
    required this.future,
    this.size = 40,
  }) : super(key: key);

  final Future<File?> future;
  final String? personInitials;
  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    const iconColor = ApplicationTheme.profileImagePlaceholderIconColor;
    final bgColor = ApplicationTheme.profileImagePlaceholderIconBackgroundColor;

    return FutureBuilder<File?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ProfileImage(
            icon: icon,
            image: snapshot.data,
            size: size,
            personInitials: personInitials,
            iconColor: iconColor,
            backgroundColor: bgColor,
          );
        }

        return SizedBox.square(
          dimension: size,
          child: const Center(child: PlatformAwareLoadingIndicator()),
        );
      },
    );
  }
}
