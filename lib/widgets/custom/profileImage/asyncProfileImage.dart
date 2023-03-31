import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

/// This widget asynchronously loads a given profile image.
/// When the image could not be loaded, the given initials are displayed.
class AsyncProfileImage extends StatelessWidget {
  const AsyncProfileImage({
    Key? key,
    this.personInitials,
    required this.icon,
    required this.future,
    this.size = 40,
  })  : assert(size > 0),
        super(key: key);

  final Future<File?> future;
  final String? personInitials;
  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return ProfileImage(
              icon: icon,
              image: null,
              size: size,
              personInitials: personInitials,
              iconColor: ApplicationTheme.profileImagePlaceholderIconColor,
              backgroundColor:
                  ApplicationTheme.profileImagePlaceholderIconBackgroundColor,
            );
          }

          return ProfileImage(
            icon: icon,
            image: snapshot.data,
            size: size,
            personInitials: personInitials,
            iconColor: ApplicationTheme.profileImagePlaceholderIconColor,
            backgroundColor:
                ApplicationTheme.profileImagePlaceholderIconBackgroundColor,
          );
        } else {
          return SizedBox(
            width: size,
            height: size,
            child: const Center(child: PlatformAwareLoadingIndicator()),
          );
        }
      },
    );
  }
}
