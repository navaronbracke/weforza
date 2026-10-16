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
