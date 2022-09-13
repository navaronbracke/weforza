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

        final loading = SizedBox.square(
          dimension: size,
          child: const Center(child: PlatformAwareLoadingIndicator()),
        );

        if (value.selecting) {
          return loading;
        }

        return GestureDetector(
          onTap: delegate.pickImage,
          onLongPress: delegate.clearImage,
          child: PlatformAwareWidget(
            android: () => _AsyncProfileImage(
              future: value.image,
              icon: Icons.camera_alt,
              loading: loading,
              size: size,
            ),
            ios: () => _AsyncProfileImage(
              future: value.image,
              icon: CupertinoIcons.camera_fill,
              loading: loading,
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
    required this.loading,
    required this.size,
  });

  /// The future that represents the loading of the image.
  final Future<File?>? future;

  /// The icon that is used as fallback if the image is not available.
  final IconData icon;

  /// The widget that is displayed when the image is loading.
  final Widget loading;

  /// The size of this widget.
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
        loading: loading,
        size: size,
      ),
    );
  }
}
