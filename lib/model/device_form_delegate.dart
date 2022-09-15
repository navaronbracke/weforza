import 'package:weforza/model/device_payload.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';

/// This class represents the delegate for the add / edit device form.
class DeviceFormDelegate {
  DeviceFormDelegate({required this.notifier});

  /// The notifier that handles adding and editing devices.
  final SelectedMemberDevicesNotifier notifier;

  /// Add a new device.
  Future<void> addDevice(DevicePayload model) => notifier.addDevice(model);

  /// Edit an existing device.
  Future<void> editDevice(DevicePayload model) => notifier.editDevice(model);
}
