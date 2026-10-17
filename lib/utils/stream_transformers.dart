import 'dart:async';

/// Merge the given streams into a single stream.
Stream<T> mergeStreams<T>(Iterable<Stream<T>> streams) {
  final StreamController<T> controller = StreamController<T>.broadcast();
  final List<StreamSubscription<T>> subscriptions = [];

  controller.onListen = () {
    for (final stream in streams) {
      subscriptions.add(stream.listen(controller.add, onError: controller.addError));
    }
  };

  controller.onCancel = () {
    for (final sub in subscriptions) {
      unawaited(sub.cancel());
    }
  };

  return controller.stream;
}

/// Emits values from the source stream until the [trigger] stream emits an event.
///
/// The [trigger]'s own done event is ignored.
final class TakeUntilTransformer<S> extends StreamTransformerBase<S, S> {
  TakeUntilTransformer(this.trigger);

  final Stream<Object?> trigger;

  @override
  Stream<S> bind(Stream<S> stream) {
    late StreamController<S> controller;
    StreamSubscription<S>? sourceSubscription;
    StreamSubscription<Object?>? triggerSubscription;

    void stop() {
      sourceSubscription?.cancel();
      triggerSubscription?.cancel();

      if (!controller.isClosed) {
        controller.close();
      }
    }

    controller = StreamController<S>(
      onPause: () => sourceSubscription?.pause(),
      onResume: () => sourceSubscription?.resume(),
      onCancel: stop,
      onListen: () {
        sourceSubscription = stream.listen(
          (data) => controller.add(data),
          onError: (Object error, StackTrace stack) => controller.addError(error, stack),
          onDone: stop,
        );
        triggerSubscription = trigger.listen(
          (_) => stop(), // Stop on first event from the trigger.
          onError: (Object error, StackTrace stack) => controller.addError(error, stack),
        );
      },
    );

    return controller.stream;
  }
}
