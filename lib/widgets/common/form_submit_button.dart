import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/async_computation_delegate.dart';

/// This widget represents a submit button for a form.
class FormSubmitButton<T> extends StatelessWidget {
  const FormSubmitButton({
    required this.delegate,
    required this.errorBuilder,
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// The provider that will be watched for changes in the async computation.
  final AsyncComputationDelegate<T> delegate;

  /// The builder for the error message.
  ///
  /// If `error` is null, the button is in the idle state.
  final Widget Function(BuildContext context, Object? error) errorBuilder;

  /// The label for the button.
  final String label;

  /// The onTap handler for the button.
  final void Function() onPressed;

  Widget _wrapWithErrorMessage({
    required Widget child,
    required Widget errorMessage,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: errorMessage,
        ),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final button = FixedHeightSubmitButton(label: label, onPressed: onPressed);
    final loadingIndicator = _wrapWithErrorMessage(
      child: const FixedHeightSubmitButton.loading(),
      errorMessage: errorBuilder(context, null),
    );

    return StreamBuilder<AsyncValue<T>?>(
      initialData: delegate.currentState,
      stream: delegate.stream,
      builder: (context, snapshot) {
        final value = snapshot.data;

        if (value == null) {
          return _wrapWithErrorMessage(
            child: button,
            errorMessage: errorBuilder(context, null),
          );
        }

        return value.when(
          // The submit button does not have a done state.
          data: (value) => loadingIndicator,
          error: (error, stackTrace) => _wrapWithErrorMessage(
            child: button,
            errorMessage: errorBuilder(context, error),
          ),
          loading: () => loadingIndicator,
        );
      },
    );
  }
}

/// This widget represents a submit button
/// that preserves its height when transitioning to its [loading] state.
class FixedHeightSubmitButton extends StatelessWidget {
  /// Construct a [FixedHeightSubmitButton] in the idle state.
  ///
  /// If [onPressed] is null, the button will be disabled.
  const FixedHeightSubmitButton({
    required this.label,
    super.key,
    this.onPressed,
  }) : loading = false;

  /// Construct a [FixedHeightSubmitButton] in the loading state.
  const FixedHeightSubmitButton.loading({super.key})
      : label = '',
        loading = true,
        onPressed = null;

  /// The label for the submit button.
  final String label;

  /// Whether the button should show its loading indicator.
  ///
  /// If this is false, the submit button is shown instead.
  final bool loading;

  /// The onPressed handler for the button.
  ///
  /// If this is null, the button will be disabled.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: onPressed, child: Text(label));
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return loading
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: SizedBox(
                  height: kMinInteractiveDimensionCupertino,
                  child: Center(child: CupertinoActivityIndicator()),
                ),
              )
            : CupertinoButton(onPressed: onPressed, child: Text(label));
    }
  }
}
