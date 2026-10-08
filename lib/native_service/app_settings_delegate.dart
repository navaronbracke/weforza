import 'package:weforza/native_service/native_service.dart';

/// This class represents a [NativeService] for managing the app settings on the device.
final class AppSettingsDelegate extends NativeService {
  const AppSettingsDelegate();

  /// Open the general app settings page for the application.
  Future<void> openAppSettings() async {
    await methodChannel.invokeMethod<void>('openAppSettings');
  }

  /// Open the Bluetooth settings page for the device.
  ///
  /// This is only supported on Android.
  /// On other platforms this will fall back to [openAppSettings].
  Future<void> openBluetoothSettings() async {
    await methodChannel.invokeMethod<void>('openBluetoothSettings');
  }
}
