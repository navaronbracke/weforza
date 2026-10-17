import 'dart:async';

/// Merge the given streams into a single stream.
Stream<T> mergeStreams<T>(Iterable<Stream<T>> streams) {
  final List<StreamSubscription<T>> subscriptions = [];
  final StreamController<T> controller = StreamController<T>(
    onCancel: () {
      for (final sub in subscriptions) {
        unawaited(sub.cancel());
      }
    },
    onPause: () {
      for (final sub in subscriptions) {
        sub.pause();
      }
    },
    onResume: () {
      for (final sub in subscriptions) {
        sub.resume();
      }
    },
  );

  // Defined here since the callback requires the controller to be declared.
  controller.onListen = () {
    for (final stream in streams) {
      subscriptions.add(stream.listen(controller.add, onError: controller.addError));
    }
  };

  return controller.stream;
}

/// Emits values from the source stream until the [trigger] stream emits an event.
///
/// The [trigger]'s own done event is ignored.
final class TakeUntilTransformer<S> extends StreamTransformerBase<S, S> {
  const TakeUntilTransformer(this.trigger);

  final Stream<Object?> trigger;

  @override
  Stream<S> bind(Stream<S> stream) {
    StreamSubscription<S>? sourceSubscription;
    StreamSubscription<Object?>? triggerSubscription;
    final StreamController<S> controller = StreamController(
      onPause: () => sourceSubscription?.pause(),
      onResume: () => sourceSubscription?.resume(),
    );

    void stop() {
      sourceSubscription?.cancel();
      triggerSubscription?.cancel();

      if (!controller.isClosed) {
        controller.close();
      }
    }

    // Defined here since the callback requires the controller to be declared.
    controller.onCancel = stop;
    controller.onListen = () {
      sourceSubscription = stream.listen(controller.add, onError: controller.addError, onDone: stop);
      triggerSubscription = trigger.listen(
        (_) => stop(), // Stop on first event from the trigger.
        onError: controller.addError,
      );
    };

    return controller.stream;
  }
}
