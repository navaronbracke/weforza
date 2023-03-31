import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';

class MemberFormSubmitButton extends FormSubmitButton {
  const MemberFormSubmitButton({
    super.key,
    required super.initialData,
    required super.onPressed,
    required super.stream,
    required super.submitButtonLabel,
  });

  @override
  String translateError(Object error, S translator) {
    if (error is MemberExistsException) {
      return translator.MemberAlreadyExists;
    }

    return translator.GenericError;
  }
}
