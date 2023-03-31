import 'package:flutter/material.dart';
import 'package:weforza/model/add_ride_form_delegate.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar_item.dart';
import 'package:weforza/widgets/custom/date_picker/date_picker.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class AddRideCalendar extends StatelessWidget {
  const AddRideCalendar({super.key, required this.delegate});

  final AddRideFormDelegate delegate;

  @override
  Widget build(BuildContext context) {
    final calendarDelegate = delegate.calendarDelegate;

    return DatePicker(
      backButton: PlatformAwareWidget(
        android: () => IconButton(
          icon: const Icon(Icons.arrow_back),
          color: ApplicationTheme.choiceArrowIdleColor,
          splashColor: ApplicationTheme.choiceArrowOnPressedColor,
          onPressed: calendarDelegate.goBackOneMonth,
        ),
        ios: () => Padding(
          // The left chevron is more to the left.
          padding: const EdgeInsets.only(left: 8),
          child: CupertinoIconButton.fromAppTheme(
            icon: Icons.arrow_back_ios,
            onPressed: calendarDelegate.goBackOneMonth,
          ),
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 364),
      dayBuilder: (DateTime date, bool isCurrentMonth) {
        if (!isCurrentMonth) {
          return const SizedBox.square(dimension: 40);
        }

        return AddRideCalendarItem(date: date, delegate: delegate);
      },
      delegate: calendarDelegate,
      forwardButton: PlatformAwareWidget(
        android: () => IconButton(
          icon: const Icon(Icons.arrow_forward),
          color: ApplicationTheme.choiceArrowIdleColor,
          splashColor: ApplicationTheme.choiceArrowOnPressedColor,
          onPressed: calendarDelegate.goForwardOneMonth,
        ),
        ios: () => Padding(
          padding: const EdgeInsets.only(right: 4),
          child: CupertinoIconButton.fromAppTheme(
            icon: Icons.arrow_forward_ios,
            onPressed: calendarDelegate.goForwardOneMonth,
          ),
        ),
      ),
      monthStyle: const TextStyle(
        color: ApplicationTheme.rideCalendarHeaderColor,
      ),
      weekDayWidth: 40,
      weekPadding: const EdgeInsets.symmetric(vertical: 4),
      showWeekdays: true,
    );
  }
}
