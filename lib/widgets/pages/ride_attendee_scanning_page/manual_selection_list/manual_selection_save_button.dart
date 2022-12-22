import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents the save button for the manual selection page.
class ManualSelectionSaveButton extends StatefulWidget {
  const ManualSelectionSaveButton({
    required this.onPressed,
    super.key,
    this.future,
  });

  /// The Future that represents the save attendees computation.
  final Future<void>? future;

  /// The onTap handler for the save button.
  final void Function() onPressed;

  @override
  State<ManualSelectionSaveButton> createState() =>
      _ManualSelectionSaveButtonState();
}

class _ManualSelectionSaveButtonState extends State<ManualSelectionSaveButton> {
  void _onSaveButtonPressed() {
    widget.onPressed();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: widget.future,
      builder: (context, snapshot) {
        final translator = S.of(context);

        if (snapshot.connectionState == ConnectionState.none) {
          return _SaveButton(
            onPressed: _onSaveButtonPressed,
            text: translator.Save,
          );
        }

        final loadingIndicator = PlatformAwareWidget(
          android: (_) => const SizedBox.square(
            dimension: 30,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
          ios: (_) => const CupertinoActivityIndicator(),
        );

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return _SaveButton(
              onPressed: _onSaveButtonPressed,
              text: translator.TryAgain,
            );
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
      android: (_) => ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.manualSelectionBottomBar.saveButtonColor,
          foregroundColor: Colors.white,
        ),
        child: Text(text),
      ),
      ios: (_) => CupertinoButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
