import 'package:weforza/database/devices.dart';

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

    if (Devices.nameLength.max < value.length) {
      return maxLengthMessage;
    }

    return value.contains(',') ? illegalCharachterMessage : null;
  }
}
