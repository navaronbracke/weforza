import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/native_service/media_permissions_service.dart';

final class MediaPermissionsDelegate extends MediaPermissionsService {
  const MediaPermissionsDelegate();

  @override
  Future<void> requestCameraPermission() async {
    final bool result = await methodChannel.invokeMethod<bool>('requestCameraPermission') ?? false;

    if (!result) {
      throw CameraPermissionDeniedException();
    }
  }

  @override
  Future<bool> requestPhotoLibraryPermission() async {
    final bool result = await methodChannel.invokeMethod<bool>('requestPhotoLibraryPermission') ?? false;

    return result;
  }
}
