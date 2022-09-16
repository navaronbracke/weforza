/// This mixin defines a method for adding an artificial delay to a computation.
///
/// This mixin is primarily used for two situations:
/// 1) An artificial delay might make things look smoother
/// 2) A computation might finish with an error
///    before the event loop has had time to install error handler
///    (i.e. in a `FutureBuilder`)
mixin ArtificialDelay {
  /// Wait for a delay that spans the given [duration].
  Future<void> waitForDelay({
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return Future.delayed(duration);
  }
}
