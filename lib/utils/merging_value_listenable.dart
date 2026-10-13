import 'package:flutter/foundation.dart' show ValueListenable, VoidCallback;

/// A [ValueListenable] that merges the values of two other [ValueListenable]s into a record.
final class MergingValueListenable<T1, T2> extends ValueListenable<(T1, T2)> {
  const MergingValueListenable(this._first, this._second);

  final ValueListenable<T1> _first;
  final ValueListenable<T2> _second;

  @override
  (T1, T2) get value => (_first.value, _second.value);

  @override
  void addListener(VoidCallback listener) {
    _first.addListener(listener);
    _second.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _first.removeListener(listener);
    _second.removeListener(listener);
  }
}
