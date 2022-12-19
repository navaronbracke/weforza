import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'package:weforza/widgets/custom/date_picker/date_picker_delegate.dart';

/// This typedef defines the signature for the [DatePicker]'s day builder.
///
/// The `date` is the day that will be built.
/// The `isCurrentMonth` flag indicates if the `date`
/// is in the currently selected month.
/// The `size` is the computed layout [Size] for the day item.
typedef DatePickerDayBuilder = Widget Function(
  DateTime date,
  bool isCurrentMonth,
  Size size,
);

/// This typedef defines the signature
/// for the [DatePicker]'s forward and back button builder.
typedef DatePickerHeaderButtonBuilder = Widget Function(
  void Function() onPressed,
  double iconSize,
);

/// This widget represents a date picker.
class DatePicker extends StatelessWidget {
  /// The default constructor.
  const DatePicker({
    super.key,
    required this.computeDaySize,
    required this.dayBuilder,
    required this.delegate,
    this.headerBottomPadding = 0.0,
    required this.headerButtonBuilder,
    this.monthStyle,
    this.padding = EdgeInsets.zero,
    this.showWeekdays = false,
    this.weekDayStyle = const TextStyle(fontSize: 16, height: 1),
    this.weekSpacing = 0.0,
  });

  /// The function that computes the [Size] of individual day items.
  ///
  /// This function recieves the minimum and maximum size `constraints`
  /// for the day items.
  final Size Function(BoxConstraints constraints) computeDaySize;

  /// The builder that creates a [Widget] for a given day.
  final DatePickerDayBuilder dayBuilder;

  /// The delegate that manages the date picker.
  final DatePickerDelegate delegate;

  /// The bottom padding for the calendar header.
  ///
  /// Defaults to zero.
  final double headerBottomPadding;

  /// The builder for the header forward and back buttons.
  final DatePickerHeaderButtonBuilder headerButtonBuilder;

  /// The style for the calendar month text in the header.
  final TextStyle? monthStyle;

  /// The padding for the entire calendar.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets padding;

  /// Whether to show the days of the week above the days of the month.
  ///
  /// Defaults to false.
  final bool showWeekdays;

  /// The [TextStyle] for the weekday labels.
  ///
  /// This text style should have a non-null [TextStyle.fontSize] and [TextStyle.height].
  ///
  /// Defaults to a [TextStyle] with a fontSize of 16 and a height factor of 1.
  final TextStyle weekDayStyle;

  /// The spacing between weeks in the calendar.
  ///
  /// Defaults to zero.
  final double weekSpacing;

  /// Compute the total height for the date picker.
  /// The total height is the sum of:
  /// - [headerHeight]
  /// - [headerBottomPadding]
  /// - the height of the weekday labels
  /// - the total height of all weeks
  /// - the total vertical spacing between all weeks
  ///
  /// The calendar always shows `6` weeks.
  double _computeHeight(Size dayItemSize, double headerHeight) {
    // The calendar always shows six weeks.
    // The last week does not get any bottom padding.
    final totalWeekSpacing = weekSpacing == 0 ? 0 : 5 * weekSpacing;
    final totalWeekHeight = 6 * dayItemSize.height;

    final totalHeaderHeight = headerHeight + headerBottomPadding;

    double weekDayHeight = 0.0;

    if (showWeekdays) {
      final weekDayFontSize = weekDayStyle.fontSize;
      final weekDayLineHeight = weekDayStyle.height;

      assert(
        weekDayFontSize != null && weekDayLineHeight != null,
        'The fontSize and height of `weekDayStyle` is required if showWeekdays is true',
      );

      weekDayHeight = weekDayFontSize! * weekDayLineHeight!;
    }

    return totalHeaderHeight +
        totalWeekHeight +
        totalWeekSpacing +
        weekDayHeight;
  }

  @override
  Widget build(BuildContext context) {
    double minInteractiveDimension;

    // Get the minimum recommended size per platform.
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        minInteractiveDimension = kMinInteractiveDimension;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        minInteractiveDimension = kMinInteractiveDimensionCupertino;
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final constraintWidth = constraints.biggest.width;
        // The max size for day items is equal to filling the constraint width.
        final maxSize = constraintWidth / 7;

        // Compute the minimum size for a day item.
        // If the constraint with is smaller than the recommended min size,
        // scale the minimum to fit the screen.
        final minSize = constraintWidth < minInteractiveDimension * 7
            ? maxSize
            : minInteractiveDimension;

        final Size dayItemSize = computeDaySize(
          BoxConstraints(
            maxHeight: maxSize,
            maxWidth: maxSize,
            minHeight: minSize,
            minWidth: minSize,
          ),
        );

        // Center the header within the weeks of the calendar.
        // Otherwise the forward & back button extend too far out.
        Widget header = Center(
          child: SizedBox(
            width: dayItemSize.width * 7,
            child: _DatePickerHeader(
              backButton: headerButtonBuilder(
                delegate.goBackOneMonth,
                minInteractiveDimension,
              ),
              forwardButton: headerButtonBuilder(
                delegate.goForwardOneMonth,
                minInteractiveDimension,
              ),
              initialMonth: delegate.currentCalendarMonth,
              monthStream: delegate.monthStream,
              style: monthStyle,
            ),
          ),
        );

        if (headerBottomPadding > 0) {
          header = Padding(
            padding: EdgeInsets.only(bottom: headerBottomPadding),
            child: header,
          );
        }

        Widget calendar = Column(
          children: <Widget>[
            header,
            Expanded(
              child: _DatePickerBody(
                dayBuilder: dayBuilder,
                dayItemSize: dayItemSize,
                delegate: delegate,
                showWeekdays: showWeekdays,
                weekDayStyle: weekDayStyle,
                weekSpacing: weekSpacing,
              ),
            ),
          ],
        );

        if (padding != EdgeInsets.zero) {
          calendar = Padding(
            padding: padding,
            child: calendar,
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: _computeHeight(
              dayItemSize,
              minInteractiveDimension, // The header is as tall as its buttons.
            ),
          ),
          child: calendar,
        );
      },
    );
  }
}

/// This class represents the body for a [DatePicker].
/// This body is placed under the [_DatePickerHeader].
class _DatePickerBody extends StatelessWidget {
  const _DatePickerBody({
    required this.dayBuilder,
    required this.dayItemSize,
    required this.delegate,
    required this.showWeekdays,
    required this.weekDayStyle,
    required this.weekSpacing,
  });

  final DatePickerDayBuilder dayBuilder;

  final Size dayItemSize;

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
          width: dayItemSize.width,
          child: Center(
            child: Text(dateFormat.format(date), style: weekDayStyle),
          ),
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
                final currentMonth = delegate.currentCalendarMonth.dateTime;
                final days = delegate.computeDaysForMonth();

                return _DatePickerMonth(
                  key: ValueKey<DateTime>(currentMonth),
                  days: days.map((day) {
                    return dayBuilder(
                      day,
                      day.month == currentMonth.month,
                      dayItemSize,
                    );
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
    required this.initialMonth,
    required this.monthStream,
    this.style,
  });

  /// The button that navigates back one month when tapped.
  final Widget backButton;

  /// The button that navigates forward one month when tapped.
  final Widget forwardButton;

  /// The initial month for the header.
  final Jiffy initialMonth;

  /// The stream that provides updates about the current month.
  final Stream<Jiffy> monthStream;

  /// The style for the month text.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Jiffy>(
      initialData: initialMonth,
      stream: monthStream,
      builder: (context, snapshot) {
        final month = snapshot.data?.dateTime;
        final languageCode = Localizations.localeOf(context).languageCode;

        return Row(
          children: [
            backButton,
            Expanded(
              child: Center(
                child: Text(
                  month == null
                      ? ''
                      : DateFormat.MMMM(languageCode).add_y().format(month),
                  style: style,
                ),
              ),
            ),
            forwardButton,
          ],
        );
      },
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
