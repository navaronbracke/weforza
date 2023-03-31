extension ToStringNoMillis on DateTime {
  /// Convert the given date to a 'YYYY-MM-DD HH:MM:SS' string.
  /// E.g. 1969-07-20 20:18:04
  String toStringWithoutMilliseconds() {
    final String s = toString();

    // Strip the milliseconds.
    return s.substring(0, s.length - 5);
  }
}
