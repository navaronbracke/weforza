import 'package:flutter/cupertino.dart';
import 'package:weforza/theme/app_theme.dart';

/// This widget represents a [CupertinoTextField] that has a validation message.
class CupertinoFormField extends StatelessWidget {
  const CupertinoFormField({
    Key? key,
    this.autocorrect = false,
    required this.controller,
    required this.errorMessageStream,
    required this.focusNode,
    this.initialErrorMessage = '',
    this.keyboardType,
    required this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
  }) : super(key: key);

  final bool autocorrect;

  final TextEditingController controller;

  final Stream<String> errorMessageStream;

  final FocusNode focusNode;

  final String initialErrorMessage;

  final TextInputType? keyboardType;

  final void Function(String) onChanged;

  final void Function(String)? onSubmitted;

  final String? placeholder;

  final TextCapitalization textCapitalization;

  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
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
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
        StreamBuilder<String>(
          initialData: initialErrorMessage,
          stream: errorMessageStream,
          builder: (context, snapshot) {
            final message = snapshot.data ?? '';

            return Text(message, style: ApplicationTheme.iosFormErrorStyle);
          },
        ),
      ],
    );
  }
}
