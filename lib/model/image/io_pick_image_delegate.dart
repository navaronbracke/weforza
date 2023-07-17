import 'dart:io' show Platform;

import 'package:file/file.dart' as fs;
import 'package:image_picker/image_picker.dart';
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
  /// On Android 9 and lower this requests permission to read/write to external storage.
  /// On iOS this requests permission to add a photo to the Photo library.
  ///
  /// If any permission is not granted, this returns a [Future.error].
  Future<void> _requestCameraAndPhotoLibraryPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await mediaPermissionsDelegate.requestCameraPermission();
    }

    if (Platform.isAndroid && !fileSystem.hasScopedStorage) {
      // Request both read and write permission of the external storage.
      // The write permission is required to save the image, while the read permission is required
      // to view the image later, after it was saved.
      final bool hasExternalStoragePermission = await fileStorageDelegate.requestExternalStoragePermission(
        read: true,
        write: true,
      );

      if (!hasExternalStoragePermission) {
        throw ExternalStoragePermissionDeniedException();
      }
    }

    if (Platform.isIOS) {
      final bool hasPhotosPermission = await mediaPermissionsDelegate.requestPhotoLibraryPermission();

      if (!hasPhotosPermission) {
        throw PhotoLibraryPermissionDeniedException();
      }
    }
  }

  /// Take a new photo with the camera of the device.
  ///
  /// If permissions are denied, this returns a [Future.error].
  Future<fs.File?> _takePhotoWithCamera() async {
    return null; // TODO: testing permissions first
  }

  @override
  Future<fs.File?> pickProfileImage(ImageSource source) async {
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

        return fileSystem.file(profileImage.path);
    }
  }
}
