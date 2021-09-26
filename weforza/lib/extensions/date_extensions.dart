extension SimpleToString on DateTime {
  // Pad a number with zeroes so it becomes a two digit one.
  String _padLeft(int number) => number.toString().padLeft(2,"0");

  // Returns a simple date string.
  // I.e. 2012-02-27 13:27:00
  String toStringSimple(){
    final month = _padLeft(this.month);
    final day = _padLeft(this.day);
    final hour = _padLeft(this.hour);
    final minute = _padLeft(this.minute);
    final second = _padLeft(this.second);

    return "$year-$month-$day $hour:$minute:$second";
  }
}