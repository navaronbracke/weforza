/// @docImport 'package:weforza/database/database.dart';
library;

/// An exception that is thrown when a [Rider] fails validation.
sealed class RiderValidationException implements Exception {
  const new();
}

/// An exception that is thrown when a [Rider] already exists.
final class RiderExistsException extends RiderValidationException {}
