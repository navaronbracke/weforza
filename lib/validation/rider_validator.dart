/// @docImport 'package:weforza/database/database.dart';
library;

import 'package:weforza/database/riders.dart';
import 'package:weforza/exceptions/rider_name_validation_exception.dart';
import 'package:weforza/generated/l10n.dart';

/// A model validator that validates [Rider] models.
final class RiderValidator {
  /// Validates the given rider name.
  static bool isValidRiderName({required String? firstName, required String? lastName, required String? alias}) {
    return validateFirstOrLastName(firstName) == null &&
        validateFirstOrLastName(lastName) == null &&
        validateAlias(alias) == null;
  }

  /// Validate the given [value] as a [Rider.alias].
  ///
  /// Returns null if the [value] is valid.
  /// Returns an appropriate [RiderNameValidationException] if the [value] is invalid.
  static RiderNameValidationException? validateAlias(String? value) {
    // Only the empty string is a valid blank value.
    if (value == null || value.isNotEmpty && value.trim().isEmpty) {
      return const RiderNameIsBlankException();
    }

    if (Riders.nameAndAliasLength.max < value.length) {
      return const RiderNameTooLongException();
    }

    if (value.isEmpty || Riders.nameAndAliasRegex.hasMatch(value)) {
      return null;
    }

    return const RiderNameContainsIllegalCharacterException();
  }

  /// Validate the given [value] as a [Rider.alias] and return an appropriate error message.
  ///
  /// See [validateAlias] for the underlying validation logic.
  static String? validateAliasWithErrorMessage(S translator, String? value) {
    return switch (validateAlias(value)) {
      RiderNameContainsIllegalCharacterException() => translator.aliasIllegalCharacters,
      RiderNameIsBlankException() => translator.aliasBlank,
      RiderNameTooLongException() => translator.aliasMaxLength(Riders.nameAndAliasLength.max),
      RiderNameRequiredException() || null => null,
    };
  }

  /// Validate the given [value] as a [Rider.firstName] or [Rider.lastName].
  ///
  /// Returns null if the [value] is valid.
  /// Returns an appropriate [RiderNameValidationException] if the [value] is invalid.
  static RiderNameValidationException? validateFirstOrLastName(String? value) {
    if (value == null || value.isEmpty) {
      return const RiderNameRequiredException();
    }

    if (value.trim().isEmpty) {
      return const RiderNameIsBlankException();
    }

    if (Riders.nameAndAliasLength.max < value.length) {
      return const RiderNameTooLongException();
    }

    return Riders.nameAndAliasRegex.hasMatch(value) ? null : const RiderNameContainsIllegalCharacterException();
  }

  /// Validate the given [value] as a [Rider.firstName] and return an appropriate error message.
  ///
  /// See [validateFirstOrLastName] for the underlying validation logic.
  static String? validateFirstNameWithErrorMessage(S translator, String? value) {
    return switch (validateFirstOrLastName(value)) {
      RiderNameContainsIllegalCharacterException() => translator.firstNameIllegalCharacters,
      RiderNameIsBlankException() => translator.firstNameBlank,
      RiderNameTooLongException() => translator.firstNameMaxLength(Riders.nameAndAliasLength.max),
      RiderNameRequiredException() => translator.firstNameRequired,
      null => null,
    };
  }

  /// Validate the given [value] as a [Rider.lastName] and return an appropriate error message.
  ///
  /// See [validateFirstOrLastName] for the underlying validation logic.
  static String? validateLastNameWithErrorMessage(S translator, String? value) {
    return switch (validateFirstOrLastName(value)) {
      RiderNameContainsIllegalCharacterException() => translator.lastNameIllegalCharacters,
      RiderNameIsBlankException() => translator.lastNameBlank,
      RiderNameTooLongException() => translator.lastNameMaxLength(Riders.nameAndAliasLength.max),
      RiderNameRequiredException() => translator.lastNameRequired,
      null => null,
    };
  }
}
