import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    final button = PlatformAwareWidget(
      android: (_) => ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
      ios: (_) => CupertinoButton.filled(
        onPressed: onPressed,
        child: Text(label),
      ),
    );

    const loading = PlatformAwareLoadingIndicator();

    return StreamBuilder<AsyncValue<T>?>(
      initialData: delegate.currentState,
      stream: delegate.stream,
      builder: (context, snapshot) {
        final value = snapshot.data;

        if (value == null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: errorBuilder(context, null),
              ),
              button,
            ],
          );
        }

        return value.when(
          // The submit button does not have a done state.
          data: (value) => loading,
          error: (error, stackTrace) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: errorBuilder(context, error),
              ),
              button,
            ],
          ),
          loading: () => loading,
        );
      },
    );
  }
}
