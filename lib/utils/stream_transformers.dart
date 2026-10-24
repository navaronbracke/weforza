import 'dart:async';

/// A [StreamTransformer] that executes the given callback when the [Stream] is canceled.
final class OnCancelTransformer<S> extends StreamTransformerBase<S, S> {
  const new(this._onCancel);

  final void Function() _onCancel;

  @override
  Stream<S> bind(Stream<S> stream) {
    StreamSubscription<S>? subscription;
    final StreamController<S> controller = StreamController<S>(
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () async {
        await subscription?.cancel();
        _onCancel();
      },
    );

    // Defined here since the callback requires the controller to be declared.
    controller.onListen = () {
      subscription = stream.listen(controller.add, onError: controller.addError, onDone: controller.close);
    };

    return controller.stream;
  }
}
