import 'package:flutter/widgets.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/device_model.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';

/// This class represents the delegate for the add / edit device form.
class DeviceFormDelegate extends AsyncComputationDelegate<void> {
  DeviceFormDelegate({required this.notifier});

  /// The [Key] for the device name input field.
  final GlobalKey<FormFieldState<String>> deviceNameKey = GlobalKey();

  /// The notifier that handles adding and editing devices.
  final SelectedMemberDevicesNotifier notifier;

  /// The name of the last device that is known to exist.
  ///
  /// When the [addDevice] or [editDevice]
  /// method determines that a given device name already exists,
  /// then this field is set to that device name.
  ///
  /// When the device name is validated using the relevant validator function,
  /// it invokes [deviceExists] with the current device name,
  /// which checks equality against this field.
  String? _lastExistingDeviceName;

  /// Whether the current error is a generic error.
  ///
  /// Returns false if error is null or a [DeviceExistsException].
  /// Returns true otherwise.
  bool get hasGenericError {
    final error = currentState?.error;

    // The `DeviceExistsException` is handled using `deviceExists()`.
    if (error == null || error is DeviceExistsException) {
      return false;
    }

    return true;
  }

  /// Returns whether the given [deviceName] matches the [_lastExistingDeviceName].
  bool deviceExists(String deviceName) {
    if (_lastExistingDeviceName == null) {
      return false;
    }

    return _lastExistingDeviceName == deviceName;
  }

  void _setLastExistingDeviceName(Object error, String deviceName) {
    if (error is DeviceExistsException) {
      _lastExistingDeviceName = deviceName;
      deviceNameKey.currentState?.validate();
    }
  }

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
      _setLastExistingDeviceName(error, model.name);

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
      _setLastExistingDeviceName(error, model.name);

      setError(error, stackTrace);
    }
  }

  @override
  void reset() {
    _lastExistingDeviceName = null;
    super.reset();
  }
}
