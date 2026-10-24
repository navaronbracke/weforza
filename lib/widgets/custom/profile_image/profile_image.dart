import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/file/content_uri_image_provider.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/riverpod/file/file_storage_delegate_provider.dart';
import 'package:weforza/riverpod/file/file_system_provider.dart';

/// This widget represents a profile image.
class ProfileImage extends StatelessWidget {
  /// The default constructor.
  const new({required this.image, required this.placeholder, this.loading, this.size = 40, super.key});

  /// The profile image to show.
  final Uri? image;

  /// The widget that is displayed when the image is loading.
  ///
  /// Defaults to [placeholder].
  final Widget? loading;

  /// The widget that is displayed when the image is not available.
  final Widget placeholder;

  /// The size of this widget.
  ///
  /// Defaults to 40.
  final double size;

  @override
  Widget build(BuildContext context) {
    final Uri? imageUri = image;

    if (imageUri == null) {
      return placeholder;
    }

    if (imageUri.isScheme('content')) {
      return Consumer(
        builder: (context, ref, child) {
          return Image(
            image: ContentUriImage(uri: imageUri, fileStorageDelegate: ref.read(fileStorageDelegateProvider)),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => placeholder,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return frame == null ? loading ?? placeholder : ClipOval(child: child);
            },
          );
        },
      );
    }

    if (imageUri.isScheme('file')) {
      return Consumer(
        builder: (context, ref, child) {
          final FileSystem fileSystem = ref.read(fileSystemProvider);

          return Image.file(
            fileSystem.fileFromUri(imageUri),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => placeholder,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return frame == null ? loading ?? placeholder : ClipOval(child: child);
            },
          );
        },
      );
    }

    return placeholder;
  }
}

/// This widget represents a [ProfileImage]
/// that uses the given [personInitials] as placeholder.
/// If the [personInitials] are null or empty,
/// an adaptive placeholder icon is used instead.
class AdaptiveProfileImage extends StatelessWidget {
  /// The default constructor.
  const new({super.key, this.image, this.personInitials, this.size = 40});

  /// The image to display.
  final Uri? image;

  /// The initials of the person to use as placeholder.
  final String? personInitials;

  /// The size for this widget.
  ///
  /// Defaults to 40.
  final double size;

  /// Get the initials for the given [firstName] and [lastName].
  static String initialsForName({required String firstName, required String lastName}) {
    return firstName[0] + lastName[0];
  }

  Color _getBackgroundColor(String initials, List<Color> colors) {
    int index = initials.codeUnitAt(0);

    if (initials.length == 2) {
      index += initials.codeUnitAt(1);
    }

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final (backgroundColors, placeholderBackgroundColor, placeholderIcon) = switch (defaultTargetPlatform) {
      .android || .fuchsia || .linux || .windows => (Colors.primaries, ColorScheme.of(context).primary, Icons.person),
      .iOS || .macOS => (
        [
          // CupertinoColors.systemBlue is excluded, to prevent contrast issues
          // with CupertinoTheme.primaryColor.
          CupertinoColors.systemGreen,
          CupertinoColors.systemIndigo,
          CupertinoColors.systemOrange,
          CupertinoColors.systemPink,
          CupertinoColors.systemPurple,
          CupertinoColors.systemRed,
          CupertinoColors.systemTeal,
          CupertinoColors.systemYellow,
        ],
        CupertinoTheme.of(context).primaryColor,
        CupertinoIcons.person_fill,
      ),
    };

    final initials = personInitials;

    if (initials == null || initials.isEmpty) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          color: placeholderBackgroundColor,
        ),
        child: Center(
          child: Icon(placeholderIcon, color: Colors.white, size: .7 * size),
        ),
      );
    }

    return ProfileImage(
      image: image,
      placeholder: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          color: _getBackgroundColor(initials, backgroundColors),
        ),
        child: Center(
          child: Text(
            personInitials!.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: size / 2),
          ),
        ),
      ),
      size: size,
    );
  }
}
