import 'package:weforza/model/member.dart';

class FirstOrLastNameValidator {
  const FirstOrLastNameValidator();

  String? validate({
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

    if (value.length > Member.nameAndAliasMaxLength) {
      return maxLengthMessage;
    }

    if (!Member.personNameAndAliasRegex.hasMatch(value)) {
      return illegalCharachterMessage;
    }

    return null;
  }
}

class AliasValidator {
  const AliasValidator();

  String? validate({
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

    if (value.length > Member.nameAndAliasMaxLength) {
      return maxLengthMessage;
    }

    if (value.isNotEmpty && !Member.personNameAndAliasRegex.hasMatch(value)) {
      return illegalCharachterMessage;
    }

    return null;
  }
}
