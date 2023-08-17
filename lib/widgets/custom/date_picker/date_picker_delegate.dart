import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

/// This class defines the delegate for a `DatePicker`.
class DatePickerDelegate {
  /// The default constructor.
  ///
  /// The [calendarPagesCount] indicates how big the actual calendar is.
  /// By default the calendar has a size of 100 years in either direction.
  /// Expressed in months this is equal to `100 * 2 * 12` or 2400.
  /// The calendar starts on the middle page.
  ///
  /// The reason for this page count is
  /// that a [PageController] does not allow negative page indexes.
  /// So by offsetting the initial page, going backwards *is* possible.
  ///
  /// The [curve] and [duration] can be used to customize the page transitions
  /// between months.
  factory DatePickerDelegate({
    int calendarPagesCount = 2400,
    Curve curve = Curves.easeInOut,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    // The page indexes start at zero.
    final currentPage = ((calendarPagesCount / 2).floor()) - 1;
    final today = DateTime.now();

    return DatePickerDelegate._(
      calendarPageCount: calendarPagesCount,
      curve: curve,
      duration: duration,
      initialDate: DateTime(today.year, today.month),
      pageController: PageController(initialPage: currentPage),
    );
  }

  /// The private constructor.
  DatePickerDelegate._({
    required this.calendarPageCount,
    required this.curve,
    required this.duration,
    required DateTime initialDate,
    required this.pageController,
  }) : _monthController = BehaviorSubject.seeded(initialDate);

  /// The total amount of pages in the calendar.
  /// One page equals one month.
  final int calendarPageCount;

  /// The animation curve for page transitions.
  final Curve curve;

  /// The duration for page transitions.
  final Duration duration;

  /// The controller that manages the visible page in the calendar.
  final PageController pageController;

  /// The controller that manages the selected month.
  final BehaviorSubject<DateTime> _monthController;

  /// Get the current calendar month.
  DateTime get currentCalendarMonth => _monthController.value;

  /// Get the stream for the currently selected month.
  Stream<DateTime> get monthStream => _monthController;

  /// Compute the days for the currently selected month.
  /// The first week of the current month is prepended
  /// with the last days of the previous month.
  /// The last week of the current month
  /// is filled with the first days of the next month.
  List<DateTime> computeDaysForMonth(MaterialLocalizations localizations) {
    final DateTime currentMonth = _monthController.value;

    final int daysInCurrentMonth = DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final int firstDayOffset = DateUtils.firstDayOffset(currentMonth.year, currentMonth.month, localizations);
    final List<DateTime> days = <DateTime>[];

    final DateTime previousMonth = DateUtils.addMonthsToMonthDate(currentMonth, -1);
    final int daysInPreviousMonth = DateUtils.getDaysInMonth(previousMonth.year, previousMonth.month);

    // Add enough days from the previous month to fill the offset up to this month's first day.
    // The start index is the first day of the last month that is within the offset range.
    // In other words, this is the day on which the offset would have been equal to 1.
    final int start = firstDayOffset - (firstDayOffset - 1);

    for (int i = start; i <= firstDayOffset; i++) {
      // Walk towards the firstDayOffset,
      // so that the last day that is added is the last day of the previous month.
      final int day = daysInPreviousMonth - (firstDayOffset - i);

      days.add(DateTime(previousMonth.year, previousMonth.month, day));
    }

    for (int i = 1; i <= daysInCurrentMonth; i++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, i));
    }

    // Once the days of this month have been filled,
    // there is now a set of items that might not fully fill the last week.
    // The calendar should always have a total amount of days that is a multiple of `DateTime.daysPerWeek`.
    final int amountOfDaysInLastWeek = days.length % DateTime.daysPerWeek;

    if (amountOfDaysInLastWeek != 0) {
      final int remainingDaysInWeek = DateTime.daysPerWeek - amountOfDaysInLastWeek;

      final nextMonth = DateUtils.addMonthsToMonthDate(currentMonth, 1);

      for (int i = 1; i <= remainingDaysInWeek; i++) {
        days.add(DateTime(nextMonth.year, nextMonth.month, i));
      }
    }

    return days;
  }

  /// This method handles the drag gesture for the calendar.
  void onDragCalendar(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx < 0) {
      goForwardOneMonth();

      return;
    }

    if (details.velocity.pixelsPerSecond.dx > 0) {
      goBackOneMonth();
    }
  }

  /// Go back one month in the calendar.
  void goBackOneMonth() {
    final currentMonth = _monthController.value;
    final previousMonth = DateUtils.addMonthsToMonthDate(currentMonth, -1);

    _monthController.add(previousMonth);
    pageController.previousPage(duration: duration, curve: curve);
  }

  /// Go forward one month in the calendar.
  void goForwardOneMonth() {
    final currentMonth = _monthController.value;
    final nextMonth = DateUtils.addMonthsToMonthDate(currentMonth, 1);

    _monthController.add(nextMonth);
    pageController.nextPage(duration: duration, curve: curve);
  }

  /// Dispose of this delegate.
  void dispose() {
    _monthController.close();
    pageController.dispose();
  }
}
