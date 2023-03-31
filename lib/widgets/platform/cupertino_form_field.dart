import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';

/// This widget represents a [CupertinoTextField] that has a validation message.
class CupertinoFormField extends StatelessWidget {
  const CupertinoFormField({
    Key? key,
    this.autocorrect = false,
    required this.controller,
    required this.errorController,
    required this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.validator,
  }) : super(key: key);

  final bool autocorrect;

  final TextEditingController controller;

  final BehaviorSubject<String> errorController;

  final FocusNode focusNode;

  final TextInputType? keyboardType;

  final void Function(String)? onChanged;

  final void Function(String)? onSubmitted;

  final String? placeholder;

  final TextCapitalization textCapitalization;

  final TextInputAction? textInputAction;

  final String? Function(String value, S translator)? validator;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoTextField(
          textCapitalization: textCapitalization,
          focusNode: focusNode,
          textInputAction: textInputAction,
          controller: controller,
          placeholder: placeholder,
          autocorrect: autocorrect,
          keyboardType: keyboardType,
          onChanged: (value) {
            onChanged?.call(value);

            if (validator == null) {
              return;
            }

            errorController.add(validator!(value, translator) ?? '');
          },
          onSubmitted: onSubmitted,
        ),
        StreamBuilder<String>(
          initialData: errorController.valueOrNull ?? '',
          stream: errorController,
          builder: (context, snapshot) {
            final message = snapshot.data ?? '';

            return Text(message, style: ApplicationTheme.iosFormErrorStyle);
          },
        ),
      ],
    );
  }
}
