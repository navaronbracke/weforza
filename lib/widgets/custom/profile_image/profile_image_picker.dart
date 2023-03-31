import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/profile_image_picker_delegate.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image_picker_placeholder.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents a profile image picker.
class ProfileImagePicker extends StatelessWidget {
  /// The default constructor.
  const ProfileImagePicker({
    required this.delegate,
    required this.imagePreviewSize,
    required this.pickingIndicator,
    super.key,
  });

  /// The delegate for the picker.
  final ProfileImagePickerDelegate delegate;

  /// The size for the image preview widget.
  final double imagePreviewSize;

  /// The loading indicator that is shown when an image is being chosen.
  final Widget pickingIndicator;

  Widget _buildPickerWithOptions({
    required Widget imagePreview,
    required Widget openCameraButton,
    required Widget openGalleryButton,
    Widget? deleteButton,
  }) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: imagePreview,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              openGalleryButton,
              openCameraButton,
              if (deleteButton != null) deleteButton,
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    final imageLoadingIndicator = SizedBox.square(
      dimension: imagePreviewSize,
      child: const Center(child: PlatformAwareLoadingIndicator()),
    );

    final openGalleryButton = _ProfileImagePickerButton(
      label: translator.SelectPhoto,
      onPressed: delegate.selectImageFromGallery,
    );

    final openCameraButton = _ProfileImagePickerButton(
      label: translator.TakePhoto,
      onPressed: () {}, // TODO: implement open camera button
    );

    final deleteImageButton = _ProfileImagePickerButton(
      label: translator.RemovePhoto,
      onPressed: () {}, // TODO: implement show delete dialog
      isDestructive: true,
    );

    return StreamBuilder<AsyncValue<File?>>(
      initialData: delegate.selectedImage,
      stream: delegate.stream,
      builder: (context, snapshot) {
        return snapshot.data!.when(
          data: (image) => _buildPickerWithOptions(
            imagePreview: PlatformAwareWidget(
              android: (_) => ProfileImage(
                image: image,
                loading: imageLoadingIndicator,
                placeholder: MaterialProfileImagePickerPlaceholder(
                  size: imagePreviewSize,
                ),
                size: imagePreviewSize,
              ),
              ios: (_) => ProfileImage(
                image: image,
                loading: imageLoadingIndicator,
                placeholder: CupertinoProfileImagePickerPlaceholder(
                  size: imagePreviewSize,
                ),
                size: imagePreviewSize,
              ),
            ),
            openCameraButton: openCameraButton,
            openGalleryButton: openGalleryButton,
            deleteButton: image == null ? null : deleteImageButton,
          ),
          error: (error, stackTrace) => _buildPickerWithOptions(
            imagePreview: SizedBox.square(
              dimension: imagePreviewSize,
              child: PlatformAwareIcon(
                androidIcon: Icons.warning,
                iosIcon: CupertinoIcons.exclamationmark_triangle_fill,
                size: imagePreviewSize / 2,
              ),
            ),
            openCameraButton: openCameraButton,
            openGalleryButton: openGalleryButton,
          ),
          loading: () => pickingIndicator,
        );
      },
    );
  }
}

class _ProfileImagePickerButton extends StatelessWidget {
  const _ProfileImagePickerButton({
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  /// Whether this button performs a destructive action.
  final bool isDestructive;

  /// The onPressed handler for the button.
  final void Function() onPressed;

  /// The label for the button.
  final String label;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) {
        final styles = Theme.of(context).extension<DestructiveButtons>()!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextButton(
            onPressed: onPressed,
            style: isDestructive ? styles.textButtonStyle : null,
            child: Text(label),
          ),
        );
      },
      ios: (_) => CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
        onPressed: onPressed,
        child: Text(
          label,
          style: isDestructive
              ? const TextStyle(color: CupertinoColors.destructiveRed)
              : null,
        ),
      ),
    );
  }
}
