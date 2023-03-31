extension ToStringNoMillis on DateTime {
    /// Convert the given date to a 'YYYY-MM-DD HH:MM:SSZ' string.
  /// E.g. 1969-07-20 20:18:04Z
  String toStringWithoutMilliseconds(){
    final String s = this.toString();

    // Strip the milliseconds and append a Z.
    return s.substring(0, s.length - 5) + "Z";
  }
}