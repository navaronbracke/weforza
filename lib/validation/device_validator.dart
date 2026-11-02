/// @docImport 'package:weforza/database/database.dart';
library;

import 'package:weforza/database/devices.dart';
import 'package:weforza/exceptions/device_name_validation_exception.dart';

/// A model validator that validates [Device] models.
final class DeviceValidator {
  /// Validate the given [value] as a [Device.name].
  ///
  /// Returns null if the device name is valid.
  /// Returns an appropriate [DeviceNameValidationException] if the device name is invalid.
  static DeviceNameValidationException? validateDeviceName(String? value) {
    if (value == null || value.isEmpty) {
      return const DeviceNameRequiredException();
    }

    if (value.trim().isEmpty) {
      return const DeviceNameIsBlankException();
    }

    if (Devices.nameLength.max < value.length) {
      return const DeviceNameTooLongException();
    }

    return value.contains(',') ? const DeviceNameContainsIllegalCharacterException() : null;
  }
}
