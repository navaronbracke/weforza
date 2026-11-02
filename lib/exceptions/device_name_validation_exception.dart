/// @docImport 'package:weforza/database/database.dart';
library;

/// An exception that is thrown when a [Device.name] is invalid.
sealed class DeviceNameValidationException implements Exception {
  const new();
}

/// An exception that is thrown when a [Device.name] contains an illegal character.
final class DeviceNameContainsIllegalCharacterException extends DeviceNameValidationException {
  const new();
}

/// An exception that is thrown when a [Device.name] consists of only whitespace.
final class DeviceNameIsBlankException extends DeviceNameValidationException {
  const new();
}

/// An exception that is thrown when a [Device.name] is empty.
final class DeviceNameRequiredException extends DeviceNameValidationException {
  const new();
}

/// An exception that is thrown when a [Device.name] exceeds the maximum allowed length.
final class DeviceNameTooLongException extends DeviceNameValidationException {
  const new();
}
