import 'package:weforza/native_service/native_service.dart';

/// This class represents an interface for requesting media related permissions.
abstract base class MediaPermissionsService extends NativeService {
  const MediaPermissionsService();

  /// Request permission to add photos to the photo gallery of the device.
  /// This permission only has an effect on iOS.
  ///
  /// Returns whether the permission is granted.
  Future<bool> requestAddToPhotoLibraryPermission();

  /// Request permission to use the device camera.
  ///
  /// Returns whether the permission is granted.
  Future<bool> requestCameraPermission();
}
