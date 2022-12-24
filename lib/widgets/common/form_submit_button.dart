import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a submit button for a form.
class FormSubmitButton<T> extends ConsumerWidget {
  const FormSubmitButton({
    required this.errorBuilder,
    required this.label,
    required this.onPressed,
    required this.provider,
    super.key,
  });

  /// The builder for the error message.
  ///
  /// If `error` is null, the button is in the idle state.
  final Widget Function(BuildContext context, Object? error) errorBuilder;

  /// The label for the button.
  final String label;

  /// The onTap handler for the button.
  final void Function() onPressed;

  /// The provider that will be watched for changes in the async computation.
  final ProviderListenable<AsyncValue<T>?> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);

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

    const loading = PlatformAwareLoadingIndicator();

    return value.when(
      data: (value) => loading, // The submit button does not have a done state.
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
  }
}
