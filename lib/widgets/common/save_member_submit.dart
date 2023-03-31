import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class SaveMemberSubmit extends StatelessWidget {
  const SaveMemberSubmit({
    Key? key,
    required this.buttonLabel,
    required this.future,
    required this.onPressed,
  }) : super(key: key);

  /// The label for the submit button.
  final String buttonLabel;

  /// The future that handles the submit.
  final Future<void>? future;

  /// The onTap handler for the button.
  final void Function() onPressed;

  Widget _buildButton(Widget button, [String errorMessage = '']) {
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
    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        final translator = S.of(context);

        final button = PlatformAwareWidget(
          android: () => ElevatedButton(
            child: Text(translator.AddMemberSubmit),
            onPressed: onPressed,
          ),
          ios: () => CupertinoButton.filled(
            child: Text(
              translator.AddMemberSubmit,
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: onPressed,
          ),
        );

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildButton(button);
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const PlatformAwareLoadingIndicator();
          case ConnectionState.done:
            final error = snapshot.error;

            if (error is MemberExistsException) {
              return _buildButton(button, translator.MemberAlreadyExists);
            }

            if (error != null) {
              return _buildButton(button, translator.GenericError);
            }

            return const PlatformAwareLoadingIndicator();
        }
      },
    );
  }
}
