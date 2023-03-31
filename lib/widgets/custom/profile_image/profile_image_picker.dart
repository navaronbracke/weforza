import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/profile_image_picker_delegate.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a profile image picker.
class ProfileImagePicker extends StatelessWidget {
  /// The default constructor.
  const ProfileImagePicker({
    required this.delegate,
    required this.size,
    super.key,
  });

  /// The delegate for the picker.
  final ProfileImagePickerDelegate delegate;

  /// The size for the picker.
  final double size;

  @override
  Widget build(BuildContext context) {
    final loading = SizedBox.square(
      dimension: size,
      child: const Center(child: PlatformAwareLoadingIndicator()),
    );

    return StreamBuilder<AsyncValue<File?>>(
      initialData: delegate.selectedImage,
      stream: delegate.stream,
      builder: (context, snapshot) {
        return snapshot.data!.when(
          data: (image) => GestureDetector(
            onLongPress: image == null ? null : delegate.clear,
            onTap: delegate.selectImageFromGallery,
            child: PlatformAwareWidget(
              android: (_) => ProfileImage(
                icon: Icons.camera_alt,
                image: image,
                loading: loading,
                size: size,
              ),
              ios: (_) => ProfileImage(
                icon: CupertinoIcons.camera_fill,
                image: image,
                loading: loading,
                size: size,
              ),
            ),
          ),
          error: (error, stackTrace) => SizedBox.square(
            dimension: size,
            child: Center(
              child: PlatformAwareIcon(
                androidIcon: Icons.warning,
                iosIcon: CupertinoIcons.exclamationmark_triangle_fill,
                size: size / 2,
              ),
            ),
          ),
          loading: () => loading,
        );
      },
    );
  }
}
