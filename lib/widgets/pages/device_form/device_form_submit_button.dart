import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';

class DeviceFormSubmitButton extends FormSubmitButton {
  const DeviceFormSubmitButton({
    super.key,
    required super.initialData,
    required super.onPressed,
    required super.stream,
    required super.submitButtonLabel,
  });

  @override
  String translateError(Object error, S translator) {
    if (error is DeviceExistsException) {
      return translator.DeviceExists;
    }

    return translator.GenericError;
  }
}
