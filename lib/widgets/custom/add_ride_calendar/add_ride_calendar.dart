import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/add_ride_form_delegate.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar_item.dart';
import 'package:weforza/widgets/custom/date_picker/date_picker.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart' show RideCalendarTheme;

class AddRideCalendar extends StatelessWidget {
  const AddRideCalendar({super.key, required this.delegate});

  final AddRideFormDelegate delegate;

  @override
  Widget build(BuildContext context) {
    final calendarDelegate = delegate.calendarDelegate;

    const double dayItemPadding = 4;
    const double dayItemSize = 40;
    // A weekday is as wide as a single day item and its horizontal padding.
    const double weekDayWidth = (dayItemPadding * 2) + dayItemSize;

    final theme = RideCalendarTheme.fromPlatform(context);

    return DatePicker(
      backButton: PlatformAwareWidget(
        android: (_) => IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: calendarDelegate.goBackOneMonth,
        ),
        ios: (_) => CupertinoIconButton(
          icon: CupertinoIcons.chevron_left,
          onPressed: calendarDelegate.goBackOneMonth,
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 364),
      dayBuilder: (DateTime date, bool isCurrentMonth) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: dayItemPadding),
          child: isCurrentMonth
              ? AddRideCalendarItem(
                  date: date,
                  delegate: delegate,
                  size: dayItemSize,
                  theme: theme,
                )
              : const SizedBox.square(dimension: dayItemSize),
        );
      },
      delegate: calendarDelegate,
      forwardButton: PlatformAwareWidget(
        android: (_) => IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: calendarDelegate.goForwardOneMonth,
        ),
        ios: (_) => CupertinoIconButton(
          icon: CupertinoIcons.chevron_right,
          onPressed: calendarDelegate.goForwardOneMonth,
        ),
      ),
      weekDayWidth: weekDayWidth,
      weekPadding: const EdgeInsets.symmetric(vertical: dayItemPadding),
      showWeekdays: true,
    );
  }
}
