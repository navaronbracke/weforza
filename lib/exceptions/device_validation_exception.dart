/// @docImport 'package:weforza/database/database.dart';
library;

/// An exception that is thrown when a [Device] fails validation.
sealed class DeviceValidationException implements Exception {
  const new();
}

/// An exception that is thrown when a [Device] already exists.
final class DeviceExistsException extends DeviceValidationException {}
