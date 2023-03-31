import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the save button for the manual selection page.
class ManualSelectionSaveButton extends StatelessWidget {
  const ManualSelectionSaveButton({
    super.key,
    this.future,
    required this.onPressed,
  });

  /// The Future that represents the save attendees computation.
  final Future<void>? future;

  /// The onTap handler for the save button.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        final translator = S.of(context);

        if (snapshot.connectionState == ConnectionState.none) {
          return _SaveButton(onPressed: onPressed, text: translator.Save);
        }

        final loadingIndicator = PlatformAwareWidget(
          android: () => const SizedBox.square(
            dimension: 30,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
          ios: () => const CupertinoActivityIndicator(),
        );

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return _SaveButton(onPressed: onPressed, text: translator.TryAgain);
          }

          return loadingIndicator;
        }

        return loadingIndicator;
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onPressed, required this.text});

  final void Function() onPressed;

  final String text;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary:
                  ApplicationTheme.androidManualSelectionSaveButtonPrimaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: ElevatedButton(onPressed: onPressed, child: Text(text))),
      ios: () => CupertinoButton.filled(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
