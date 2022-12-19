import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'package:weforza/widgets/custom/date_picker/date_picker_delegate.dart';

/// This widget represents a date picker.
class DatePicker extends StatelessWidget {
  /// The default constructor.
  const DatePicker({
    super.key,
    required this.backButton,
    required this.constraints,
    required this.dayBuilder,
    required this.delegate,
    required this.forwardButton,
    this.headerHeight = 50,
    this.headerPadding = EdgeInsets.zero,
    this.monthStyle,
    this.padding = EdgeInsets.zero,
    this.showWeekdays = false,
    required this.weekDayWidth,
    required this.weekPadding,
  });

  /// The widget that represents the button to go back one month.
  /// This widget is placed in the left corner of the calendar header.
  final Widget backButton;

  /// The constraints for the entire calendar.
  final BoxConstraints constraints;

  /// The builder that creates a widget for a given `date`.
  /// The `isCurrentMonth` argument indicates if the `date`
  /// is within the currently selected month.
  final Widget Function(DateTime date, bool isCurrentMonth) dayBuilder;

  /// The delegate that manages the date picker.
  final DatePickerDelegate delegate;

  /// The widget that represents the button to go forward one month.
  /// This widget is placed in the right corner of the calendar header.
  final Widget forwardButton;

  /// The bottom padding for the calendar header.
  ///
  /// Defaults to zero.
  final double headerBottomPadding;

  /// The height for the calendar header.
  ///
  /// Defaults to 50.
  final double headerHeight;

  /// The style for the calendar month text in the header.
  final TextStyle? monthStyle;

  /// The padding for the entire calendar.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets padding;

  /// Whether to show the days of the week above the days of the month.
  final bool showWeekdays;

  /// The width for a weekday in the weekday header.
  ///
  /// It is recommended that the weekdays
  /// and the days of the month have an equal width.
  final double weekDayWidth;

  /// The padding for a single week in the calendar.
  final EdgeInsets weekPadding;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: Column(
        children: <Widget>[
          Padding(
            padding: headerPadding,
            child: _DatePickerHeader(
              backButton: backButton,
              forwardButton: forwardButton,
              height: headerHeight,
              monthStream: delegate.monthStream,
              style: monthStyle,
            ),
          ),
          Expanded(
            child: _DatePickerBody(
              dayBuilder: dayBuilder,
              delegate: delegate,
              showWeekdays: showWeekdays,
              weekDayWidth: weekDayWidth,
              weekPadding: weekPadding,
            ),
          ),
        ],
      ),
    );
  }
}

/// This class represents the body for a [DatePicker].
/// This body is placed under the [_DatePickerHeader].
class _DatePickerBody extends StatelessWidget {
  const _DatePickerBody({
    required this.dayBuilder,
    required this.delegate,
    required this.showWeekdays,
    required this.weekDayStyle,
    required this.weekSpacing,
  });

  final Widget Function(DateTime date, bool isCurrentMonth) dayBuilder;

  final DatePickerDelegate delegate;

  final bool showWeekdays;

  final TextStyle weekDayStyle;

  final double weekSpacing;

  Widget _buildWeekdaysHeader(DateFormat dateFormat) {
    // This list contains the first monday - sunday of the year 1970.
    final weekDays = [
      DateTime(1970, 1, 5),
      DateTime(1970, 1, 6),
      DateTime(1970, 1, 7),
      DateTime(1970, 1, 8),
      DateTime(1970, 1, 9),
      DateTime(1970, 1, 10),
      DateTime(1970, 1, 11),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: weekDays.map((DateTime date) {
        return SizedBox(
          width: weekDayWidth,
          child: Center(child: Text(dateFormat.format(date))),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(
      'EEE',
      Localizations.localeOf(context).languageCode,
    );

    return Column(
      children: <Widget>[
        if (showWeekdays) _buildWeekdaysHeader(dateFormat),
        Expanded(
          child: GestureDetector(
            // The drag gesture is intercepted
            // to keep the PageView and the header in sync.
            onHorizontalDragEnd: delegate.onDragCalendar,
            child: PageView.builder(
              controller: delegate.pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: delegate.calendarPageCount,
              itemBuilder: (context, index) {
                final currentMonth = delegate.currentCalendarMonth;
                final days = delegate.computeDaysForMonth();

                return _DatePickerMonth(
                  key: ValueKey<DateTime>(currentMonth),
                  days: days.map((date) {
                    return dayBuilder(date, date.month == currentMonth.month);
                  }).toList(),
                  weekSpacing: weekSpacing,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// This class represents the month header for a [DatePicker].
class _DatePickerHeader extends StatelessWidget {
  const _DatePickerHeader({
    required this.backButton,
    required this.forwardButton,
    required this.height,
    required this.monthStream,
    this.style,
  });

  /// The button that navigates back one month when tapped.
  final Widget backButton;

  /// The button that navigates forward one month when tapped.
  final Widget forwardButton;

  /// The height for the month header.
  final double height;

  /// The stream that provides updates about the current month.
  final Stream<Jiffy> monthStream;

  /// The style for the month text.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: StreamBuilder<Jiffy>(
        stream: monthStream,
        builder: (context, snapshot) {
          final month = snapshot.data?.dateTime;

          if (month == null) {
            return SizedBox(height: height);
          }

          final languageCode = Localizations.localeOf(context).languageCode;

          return Row(
            children: [
              backButton,
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat.MMMM(languageCode).add_y().format(month),
                    style: style,
                  ),
                ),
              ),
              forwardButton,
            ],
          );
        },
      ),
    );
  }
}

/// This widget represents the days of a single month in a [DatePicker].
class _DatePickerMonth extends StatelessWidget {
  const _DatePickerMonth({
    required super.key,
    required this.days,
    required this.weekSpacing,
  });

  /// The days for this month.
  final List<Widget> days;

  /// The spacing between weeks.
  final double weekSpacing;

  /// Iterate over the [days] and build the rows that represent the weeks.
  List<Widget> _buildCalendarRows() {
    final weeks = <Widget>[];

    int weekCounter = 1;

    while (days.isNotEmpty) {
      final children = <Widget>[];

      // Add an entire week, or the remaining days if no week can be filled.
      final dayCount = days.length < 7 ? days.length : 7;

      for (int i = 0; i < dayCount; i++) {
        children.add(days.removeAt(0));
      }

      Widget week = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );

      // Only the last week does not get bottom spacing.
      if (weekSpacing > 0 && weekCounter < 6) {
        week = Padding(
          padding: EdgeInsets.only(bottom: weekSpacing),
          child: week,
        );
      }

      weeks.add(week);
      weekCounter += 1;
    }

    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildCalendarRows(),
    );
  }
}
