import 'package:weforza/native_service/native_service.dart';

/// This class represents an interface for requesting media related permissions.
abstract base class MediaPermissionsService extends NativeService {
  const MediaPermissionsService();

  /// Request permission to access the photo gallery of the device.
  /// This permission only has an effect on iOS.
  ///
  /// Returns a [Future.error] if the permission is denied.
  Future<bool> requestPhotoLibraryPermission();

  /// Request permission to use the device camera.
  ///
  /// Returns a [Future.error] if the permission is denied.
  Future<void> requestCameraPermission();
}
