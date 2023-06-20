extension DateTimeExtensions on DateTime {
  /// Get the amount of days in the [month] of this date.
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  /// Add a month to this date.
  ///
  /// If the current [day] is out of range for the target month,
  /// it is set to the last day of the month.
  DateTime addMonth() {
    // Determine the target month and year.
    int targetMonth = month + 1;
    int targetYear = year;

    if (targetMonth > 12) {
      // If the target month is greater than 12, adjust the year accordingly.
      targetMonth = 1;
      targetYear++;
    }

    // Calculate the last day of the target month.
    final int lastDayOfMonth = DateTime(targetYear, targetMonth + 1, 0).day;

    // Preserve the day if it is valid in the target month.
    final int targetDay = day <= lastDayOfMonth ? day : lastDayOfMonth;

    return DateTime(targetYear, targetMonth, targetDay);
  }

  /// Subtract a month from this date.
  ///
  /// If the current [day] is out of range for the target month,
  /// it is set to the last day of the month.
  DateTime subtractMonth() {
    // Determine the target month and year.
    int targetMonth = month - 1;
    int targetYear = year;

    if (targetMonth < 1) {
      // If the target month is less than 1, adjust the year accordingly.
      targetMonth = 12;
      targetYear--;
    }

    // Calculate the last day of the target month.
    final int lastDayOfMonth = DateTime(targetYear, targetMonth + 1, 0).day;

    // Preserve the day if it is valid in the target month.
    final int targetDay = day <= lastDayOfMonth ? day : lastDayOfMonth;

    return DateTime(targetYear, targetMonth, targetDay);
  }

  /// Convert the given date to a 'YYYY-MM-DD HH:MM:SS' string.
  /// E.g. 1969-07-20 20:18:04
  String toStringWithoutMilliseconds() {
    final String s = toString();

    // Strip the milliseconds and the trailing Z for UTC dates.
    return s.substring(0, s.length - (isUtc ? 5 : 4));
  }
}
