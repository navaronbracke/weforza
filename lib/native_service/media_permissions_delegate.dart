import 'package:weforza/native_service/media_permissions_service.dart';

final class MediaPermissionsDelegate extends MediaPermissionsService {
  const new();

  @override
  Future<bool> requestAddToPhotoLibraryPermission() async {
    return await methodChannel.invokeMethod<bool>('requestAddToPhotoLibraryPermission') ?? false;
  }

  @override
  Future<bool> requestCameraPermission() async {
    return await methodChannel.invokeMethod<bool>('requestCameraPermission') ?? false;
  }
}
