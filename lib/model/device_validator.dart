import 'package:weforza/model/device.dart';

mixin DeviceValidator {
  String? validateDeviceName({
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

    if (Device.nameMaxLength < value.length) {
      return maxLengthMessage;
    }

    if (value.contains(',')) {
      return illegalCharachterMessage;
    }

    return null;
  }
}
