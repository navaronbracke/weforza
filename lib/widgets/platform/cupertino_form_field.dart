import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

/// This widget represents a [CupertinoTextField] that has a validation message.
class CupertinoFormField extends StatelessWidget {
  const CupertinoFormField({
    super.key,
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
  });

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

  final String? Function(String value)? validator;

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
          onChanged: (value) {
            onChanged?.call(value);

            if (validator == null) {
              return;
            }

            errorController.add(validator!(value) ?? '');
          },
          onSubmitted: onSubmitted,
        ),
        StreamBuilder<String>(
          initialData: errorController.valueOrNull ?? '',
          stream: errorController,
          builder: (context, snapshot) {
            final message = snapshot.data ?? '';

            return Text(
              message,
              style: const TextStyle(
                color: CupertinoColors.destructiveRed,
                fontSize: 14,
              ),
            );
          },
        ),
      ],
    );
  }
}
