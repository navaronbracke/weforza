import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/device/device_model.dart';
import 'package:weforza/riverpod/rider/selected_rider_devices_provider.dart';

/// This class represents the delegate for the add / edit device form.
class DeviceFormDelegate extends AsyncComputationDelegate<void> {
  DeviceFormDelegate({required this.notifier});

  /// The notifier that handles adding and editing devices.
  final SelectedRiderDevicesNotifier notifier;

  /// Add a new device.
  /// The [whenComplete] function is called if the operation was successful.
  void addDevice(
    DeviceModel model, {
    required void Function() whenComplete,
  }) async {
    if (!canStartComputation()) {
      return;
    }

    try {
      await notifier.addDevice(model);
      setDone(null);
      whenComplete();
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }

  /// Edit an existing device.
  /// The [whenComplete] function is called if the operation was successful.
  void editDevice(
    DeviceModel model, {
    required void Function() whenComplete,
  }) async {
    if (!canStartComputation()) {
      return;
    }

    try {
      await notifier.editDevice(model);
      setDone(null);
      whenComplete();
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}
