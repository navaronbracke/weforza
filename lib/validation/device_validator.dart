/// @docImport 'package:weforza/database/database.dart';
library;

import 'package:weforza/database/devices.dart';
import 'package:weforza/exceptions/device_name_validation_exception.dart';
import 'package:weforza/generated/l10n.dart';

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

  /// Validate the given [value] as a [Device.name] and return an appropriate error message.
  ///
  /// See [validateDeviceName] for the underlying validation logic.
  static String? validateDeviceNameWithErrorMessage(S translator, String? value) {
    return switch (validateDeviceName(value)) {
      DeviceNameContainsIllegalCharacterException() => translator.deviceNameCannotContainComma,
      DeviceNameIsBlankException() => translator.deviceNameBlank,
      DeviceNameRequiredException() => translator.deviceNameRequired,
      DeviceNameTooLongException() => translator.deviceNameMaxLength(Devices.nameLength.max),
      null => null,
    };
  }
}
