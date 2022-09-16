import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a submit button for a form layout.
class FormSubmitButton extends StatefulWidget {
  const FormSubmitButton({
    super.key,
    required this.errorMessageBuilder,
    this.future,
    required this.label,
    required this.onPressed,
  });

  /// The builder that builds the error message.
  final Widget Function(Object error) errorMessageBuilder;

  /// The future that represents the submit computation.
  final Future<void>? future;

  /// The label for the submit button.
  final String label;

  /// The onPressed handler for the button.
  final void Function() onPressed;

  @override
  State<FormSubmitButton> createState() => _FormSubmitButtonState();
}

class _FormSubmitButtonState extends State<FormSubmitButton> {
  void _onSubmitButtonPressed() {
    widget.onPressed();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: widget.future,
      builder: (context, snapshot) {
        const loading = PlatformAwareLoadingIndicator();

        final button = PlatformAwareWidget(
          android: () => ElevatedButton(
            onPressed: _onSubmitButtonPressed,
            child: Text(widget.label),
          ),
          ios: () => CupertinoButton.filled(
            onPressed: _onSubmitButtonPressed,
            child: Text(
              widget.label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(''),
                ),
                button,
              ],
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return loading;
          case ConnectionState.done:
            final exception = snapshot.error;

            if (exception != null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: widget.errorMessageBuilder(exception),
                  ),
                  button,
                ],
              );
            }

            return loading;
        }
      },
    );
  }
}
