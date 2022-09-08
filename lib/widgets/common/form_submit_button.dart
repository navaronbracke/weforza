import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class FormSubmitButton extends StatelessWidget {
  const FormSubmitButton({
    Key? key,
    required this.initialData,
    required this.onPressed,
    required this.stream,
    required this.submitButtonLabel,
  }) : super(key: key);

  final bool initialData;

  final void Function() onPressed;

  final Stream<bool> stream;

  final String submitButtonLabel;

  String translateError(Object error, S translator) {
    return translator.GenericError;
  }

  Widget _buildButtonAndErrorMessage(
    Widget button, {
    String errorMessage = '',
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(errorMessage),
        ),
        button,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        final error = snapshot.error;
        final submitting = snapshot.data ?? false;

        final button = PlatformAwareWidget(
          android: () => ElevatedButton(
            onPressed: onPressed,
            child: Text(submitButtonLabel),
          ),
          ios: () => CupertinoButton.filled(
            onPressed: onPressed,
            child: Text(
              submitButtonLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );

        if (error != null) {
          return _buildButtonAndErrorMessage(
            button,
            errorMessage: translateError(error, S.of(context)),
          );
        }

        return submitting
            ? const PlatformAwareLoadingIndicator()
            : _buildButtonAndErrorMessage(button);
      },
    );
  }
}
