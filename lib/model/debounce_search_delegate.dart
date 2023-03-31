import 'package:rxdart/rxdart.dart';

/// This class represents a delegate that manages
/// a stream of search query changes.
///
/// This delegate applies a [debounceTime] to the incoming events.
class DebounceSearchDelegate {
  /// The default constructor.
  DebounceSearchDelegate({
    this.debounceTime = const Duration(milliseconds: 500),
  });

  /// The internal controller.
  final _controller = BehaviorSubject.seeded('');

  /// The debounce time for the stream events.
  final Duration debounceTime;

  /// Add a new [value] to the search query stream.
  void onQueryChanged(String value) {
    if (_controller.isClosed || _controller.value == value) {
      return;
    }

    _controller.add(value);
  }

  /// Get the stream of search query changes.
  Stream<String> get searchQuery {
    return _controller.debounceTime(debounceTime);
  }

  /// Dispose of this delegate.
  void dispose() {
    _controller.close();
  }
}
