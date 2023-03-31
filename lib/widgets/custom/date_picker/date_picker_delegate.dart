import 'package:flutter/widgets.dart'
    show Curve, Curves, DragEndDetails, PageController;

import 'package:jiffy/jiffy.dart';
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
      initialDate: Jiffy(DateTime(today.year, today.month)),
      pageController: PageController(initialPage: currentPage),
    );
  }

  /// The private constructor.
  DatePickerDelegate._({
    required this.calendarPageCount,
    required this.curve,
    required this.duration,
    required Jiffy initialDate,
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
  final BehaviorSubject<Jiffy> _monthController;

  /// Get the current calendar month.
  DateTime get currentCalendarMonth => _monthController.value.dateTime;

  /// Get the stream for the currently selected month.
  Stream<Jiffy> get monthStream => _monthController;

  /// Compute the days for the currently selected month.
  /// The first week of the current month is prepended
  /// with the last days of the previous month.
  /// The last week of the current month
  /// is filled with the first days of the next month.
  List<DateTime> computeDaysForMonth() {
    final currentMonth = _monthController.value;

    final daysInCurrentMonth = currentMonth.daysInMonth;
    final days = <DateTime>[];

    final firstDayWeekday = currentMonth.dateTime.weekday;

    // The first day of this month is not a monday.
    if (firstDayWeekday != 1) {
      final previousMonth = Jiffy(currentMonth).subtract(months: 1);

      final daysInPreviousMonth = previousMonth.daysInMonth;
      final start = daysInPreviousMonth - firstDayWeekday + 2;

      // Pad the first week of this month with days of the previous month.
      for (int i = start; i <= daysInPreviousMonth; i++) {
        days.add(DateTime(previousMonth.year, previousMonth.month, i));
      }
    }

    // Add the days of this month.
    for (int i = 0; i < daysInCurrentMonth; i++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, i + 1));
    }

    final lastDayOfCurrentMonth = DateTime(
      currentMonth.year,
      currentMonth.month,
      daysInCurrentMonth,
    );

    final lastDayWeekDay = lastDayOfCurrentMonth.weekday;

    // The last day of the current month is not a sunday.
    if (lastDayWeekDay != 7) {
      final nextMonth = Jiffy(currentMonth).add(months: 1);

      // Get the offset for the last day of this month.
      // If the last day of this month is a sunday,
      // the week is filled with days of this month.
      // Otherwise, fill the week with days of the next month.
      final endOffset = 7 - lastDayWeekDay;

      for (int i = 0; i < endOffset; i++) {
        days.add(DateTime(nextMonth.year, nextMonth.month, i + 1));
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
    final newDate = Jiffy(_monthController.value).subtract(months: 1);

    _monthController.add(newDate);
    pageController.previousPage(duration: duration, curve: curve);
  }

  /// Go forward one month in the calendar.
  void goForwardOneMonth() {
    final newDate = Jiffy(_monthController.value).add(months: 1);

    _monthController.add(newDate);
    pageController.nextPage(duration: duration, curve: curve);
  }

  /// Dispose of this delegate.
  void dispose() {
    _monthController.close();
    pageController.dispose();
  }
}
