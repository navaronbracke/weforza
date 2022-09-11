import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/profile_image_picker_delegate.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    super.key,
    required this.delegate,
    required this.size,
  });

  final ProfileImagePickerDelegate delegate;

  final double size;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SelectProfileImageState>(
      stream: delegate.stream,
      initialData: delegate.current,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(S.of(context).GenericError, softWrap: true),
          );
        }

        final value = snapshot.data!;

        if (value.selecting) {
          return SizedBox(
            width: size,
            height: size,
            child: const Center(
              child: PlatformAwareLoadingIndicator(),
            ),
          );
        }

        return GestureDetector(
          onTap: delegate.pickImage,
          onLongPress: delegate.clearImage,
          child: PlatformAwareWidget(
            android: () => _AsyncProfileImage(
              future: value.image,
              icon: Icons.camera_alt,
              size: size,
            ),
            ios: () => _AsyncProfileImage(
              future: value.image,
              icon: CupertinoIcons.camera_fill,
              size: size,
            ),
          ),
        );
      },
    );
  }
}

class _AsyncProfileImage extends StatelessWidget {
  const _AsyncProfileImage({
    this.future,
    required this.icon,
    this.size = 40,
  });

  /// The future that represents the loading of the image.
  final Future<File?>? future;

  /// The icon that is used as fallback if [personInitials] is null or empty.
  final IconData icon;

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
        size: size,
      ),
    );
  }
}
