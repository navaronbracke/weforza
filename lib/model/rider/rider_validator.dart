import 'package:weforza/database/riders.dart';

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

    if (Riders.nameAndAliasLength.max < value.length) {
      return maxLengthMessage;
    }

    return value.isEmpty || Riders.nameAndAliasRegex.hasMatch(value) ? null : illegalCharachterMessage;
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

    if (Riders.nameAndAliasLength.max < value.length) {
      return maxLengthMessage;
    }

    return Riders.nameAndAliasRegex.hasMatch(value) ? null : illegalCharachterMessage;
  }
}
