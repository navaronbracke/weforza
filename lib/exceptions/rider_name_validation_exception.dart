/// @docImport 'package:weforza/database/database.dart';
library;

/// An exception that is thrown when a [Rider.firstName], [Rider.lastName], or [Rider.alias] is invalid.
sealed class RiderNameValidationException implements Exception {
  const new();
}

/// An exception that is thrown when a [Rider.firstName], [Rider.lastName],
/// or [Rider.alias] contains an illegal character.
final class RiderNameContainsIllegalCharacterException extends RiderNameValidationException {
  const new();
}

/// An exception that is thrown when a [Rider.firstName], [Rider.lastName],
/// or [Rider.alias] consists of only whitespace.
final class RiderNameIsBlankException extends RiderNameValidationException {
  const new();
}

/// An exception that is thrown when a [Rider.firstName] or [Rider.lastName] is empty.
final class RiderNameRequiredException extends RiderNameValidationException {
  const new();
}

/// An exception that is thrown when a [Rider.firstName], [Rider.lastName],
/// or [Rider.alias] exceeds the maximum allowed length.
final class RiderNameTooLongException extends RiderNameValidationException {
  const new();
}
