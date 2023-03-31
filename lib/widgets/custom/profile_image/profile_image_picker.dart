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

/// This widget represents an action button for the button bar in a [ProfileImagePicker].
///
/// This button will use the minimum recommended size for interactive elements.
class ProfileImagePickerActionButton extends StatelessWidget {
  const ProfileImagePickerActionButton({
    required this.androidIcon,
    required this.iosIcon,
    required this.onPressed,
    this.isDestructive = false,
    super.key,
  });

  /// The icon for the Android button.
  final IconData androidIcon;

  /// The icon for the iOS button.
  final IconData iosIcon;

  /// Whether this button represents a destructive action.
  final bool isDestructive;

  /// The onPressed handler for the button.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    IconData icon;
    double size;

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        backgroundColor =
            isDestructive ? theme.colorScheme.error : theme.colorScheme.primary;
        icon = androidIcon;
        size = kMinInteractiveDimension;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        backgroundColor = isDestructive
            ? CupertinoColors.destructiveRed
            : CupertinoTheme.of(context).primaryColor;
        icon = iosIcon;
        size = kMinInteractiveDimensionCupertino;
        break;
    }

    final decorationSize = size * 0.75;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Container(
            width: decorationSize,
            height: decorationSize,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(decorationSize / 2),
              ),
            ),
            child: Center(
              child: Icon(icon, color: Colors.white, size: decorationSize / 2),
            ),
          ),
        ),
      ),
    );
  }
}

/// This widget represents a placeholder for the [ProfileImagePicker]
/// that displays an iOS-style grey circular shape
/// with a clipped person icon in the middle.
class _CupertinoProfileImagePickerPlaceholder extends StatelessWidget {
  const _CupertinoProfileImagePickerPlaceholder({required this.size});

  /// The size for the placeholder.
  final double size;

  @override
  Widget build(BuildContext context) {
    final borderWidth = size / 16;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey2,
              borderRadius: BorderRadius.all(
                Radius.circular(size / 2),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(0, borderWidth),
              child: Icon(
                CupertinoIcons.person_solid,
                color: Colors.white,
                size: size,
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(
                color: CupertinoColors.systemGrey2,
                width: borderWidth,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(size / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// This widget represents a placeholder for the [ProfileImagePicker]
/// that displays a Material-style circular shape
/// with a person icon in the middle.
class _MaterialProfileImagePickerPlaceholder extends StatelessWidget {
  const _MaterialProfileImagePickerPlaceholder({required this.size});

  /// The size of the placeholder.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
        color: Colors.grey.shade500,
      ),
      child: Center(
        child: Icon(Icons.person, color: Colors.white, size: .7 * size),
      ),
    );
  }
}
