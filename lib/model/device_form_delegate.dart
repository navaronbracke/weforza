import 'package:weforza/model/device_payload.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';

/// This class represents the delegate for the add / edit device form.
class DeviceFormDelegate {
  DeviceFormDelegate({required this.notifier});

  /// The notifier that handles adding and editing devices.
  final SelectedMemberDevicesNotifier notifier;

  /// The future that represents the submit.
  Future<void>? _future;

  /// Get the submit future.
  Future<void>? get future => _future;

  /// Add a new device.
  void addDevice(DevicePayload model) {
    _future = notifier.addDevice(model);
  }

  /// Edit an existing device.
  void editDevice(DevicePayload model) {
    _future = notifier.editDevice(model);
  }

  /// Reset the submit computation.
  void reset() {
    _future = null;
  }
}
