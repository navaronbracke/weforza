import 'package:weforza/model/rider/rider.dart';

mixin RiderValidator {
  String? validateAlias({
    required String? value,
    required String maxLengthMessage,
    required String illegalCharachterMessage,
    required String isBlankMessage,
  }) {
    // Only the empty string is a valid blank value.
    // null or only spaces are disallowed.
    if (value == null || value.isNotEmpty && value.trim().isEmpty) {
      return isBlankMessage;
    }

    if (value.length > Rider.nameAndAliasMaxLength) {
      return maxLengthMessage;
    }

    if (value.isNotEmpty && !Rider.personNameAndAliasRegex.hasMatch(value)) {
      return illegalCharachterMessage;
    }

    return null;
  }

  String? validateFirstOrLastName({
    required String? value,
    required String requiredMessage,
    required String maxLengthMessage,
    required String illegalCharachterMessage,
    required String isBlankMessage,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMessage;
    }

    if (value.trim().isEmpty) {
      return isBlankMessage;
    }

    if (value.length > Rider.nameAndAliasMaxLength) {
      return maxLengthMessage;
    }

    if (!Rider.personNameAndAliasRegex.hasMatch(value)) {
      return illegalCharachterMessage;
    }

    return null;
  }
}
