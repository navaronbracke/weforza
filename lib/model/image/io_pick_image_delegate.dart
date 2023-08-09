import 'dart:io' show Platform;

import 'package:file/file.dart' as fs;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_system.dart';
import 'package:weforza/model/image/pick_image_delegate.dart';
import 'package:weforza/native_service/file_storage_delegate.dart';
import 'package:weforza/native_service/media_permissions_service.dart';

/// The [FileSystem] based implementation of [PickImageDelegate].
class IoPickImageDelegate implements PickImageDelegate {
  IoPickImageDelegate({
    required this.fileStorageDelegate,
    required this.fileSystem,
    required this.mediaPermissionsDelegate,
  });

  final FileStorageDelegate fileStorageDelegate;

  final FileSystem fileSystem;

  final ImagePicker imagePicker = ImagePicker();

  final MediaPermissionsService mediaPermissionsDelegate;

  /// Request permission to use the camera and the relevant photo library related permissions.
  ///
  /// On Android 9 and lower this requests permission to write to external storage.
  /// On iOS this requests permission to add a photo to the Photo library.
  ///
  /// If any permission is not granted, this returns a [Future.error].
  Future<void> _requestCameraAndPhotoLibraryPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final bool hasCameraPermission = await mediaPermissionsDelegate.requestCameraPermission();

      if (!hasCameraPermission) {
        throw CameraPermissionDeniedException();
      }
    }

    if (Platform.isAndroid && !fileSystem.hasScopedStorage) {
      // Request only write permission for external storage.
      // This permission is required to save the image.
      // The read permission is not required, since reading a content Uri happens through the MediaStore.
      final bool hasExternalStoragePermission = await fileStorageDelegate.requestWriteExternalStoragePermission();

      if (!hasExternalStoragePermission) {
        throw ExternalStoragePermissionDeniedException();
      }
    }

    if (Platform.isIOS) {
      final bool hasPhotosPermission = await mediaPermissionsDelegate.requestAddToPhotoLibraryPermission();

      if (!hasPhotosPermission) {
        throw PhotoLibraryPermissionDeniedException();
      }
    }
  }

  /// Take a new photo with the camera of the device.
  ///
  /// If permissions are denied, this returns a [Future.error].
  ///
  /// Returns a [Uri] that points to the file.
  Future<Uri?> _takePhotoWithCamera() async {
    // Images from the camera get scaled down,
    // to increase the amount of thumbnails that fit in the image cache,
    // and to reduce load times of thumbnails.
    final XFile? profileImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
      maxHeight: 160,
      maxWidth: 160,
    );

    if (profileImage == null) {
      return null;
    }

    if (Platform.isAndroid) {
      final Uri? mediaStoreUri = await fileStorageDelegate.registerImage(fileSystem.file(profileImage.path));

      if (mediaStoreUri == null) {
        throw ArgumentError.notNull('mediaStoreUri');
      }

      return mediaStoreUri;
    }

    // On iOS save the image to the application documents directory.
    // This directory is accessible for the application, so no extra permissions are required.
    // After the image is saved, register it with the Photos app,
    // so that it is retained when the application is uninstalled.
    if (Platform.isIOS) {
      final fs.Directory directory = fileSystem.imagesDirectory;

      final fs.File destinationFile = fileSystem.file(join(directory.path, profileImage.name));

      await profileImage.saveTo(destinationFile.path);

      try {
        // Register the image with the Photo library.
        // On iOS, the Uri is ignored at this point, since the path to the file is known in advance.
        await fileStorageDelegate.registerImage(destinationFile);
      } catch (error) {
        // Delete the source file if registration fails.
        await destinationFile.delete();

        rethrow;
      }

      return destinationFile.uri;
    }

    // Just return the file directly as a last resort.
    return fileSystem.file(profileImage.path).uri;
  }

  @override
  Future<Uri?> pickProfileImage(ImageSource source) async {
    switch (source) {
      case ImageSource.camera:
        // When taking a photo, request permission to use the camera,
        // and to access the required storage after the photo is taken.
        await _requestCameraAndPhotoLibraryPermissions();

        return _takePhotoWithCamera();
      case ImageSource.gallery:
        // When picking from the gallery, defer to the image picker for permissions.
        // Images that come from the gallery do not get scaled, as that would create a new file.
        final XFile? profileImage = await imagePicker.pickImage(requestFullMetadata: false, source: source);

        if (profileImage == null) {
          return null;
        }

        return fileSystem.file(profileImage.path).uri;
    }
  }
}
