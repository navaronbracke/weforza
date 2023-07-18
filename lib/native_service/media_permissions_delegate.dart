import 'package:weforza/native_service/media_permissions_service.dart';

final class MediaPermissionsDelegate extends MediaPermissionsService {
  const MediaPermissionsDelegate();

  @override
  Future<bool> requestAddToPhotoLibraryPermission() async {
    final bool result = await methodChannel.invokeMethod<bool>('requestAddToPhotoLibraryPermission') ?? false;

    return result;
  }

  @override
  Future<bool> requestCameraPermission() async {
    final bool result = await methodChannel.invokeMethod<bool>('requestCameraPermission') ?? false;

    return result;
  }
}
