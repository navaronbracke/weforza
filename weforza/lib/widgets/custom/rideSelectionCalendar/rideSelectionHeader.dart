import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///The calendar header displays a label in the center.
///This label is the current month + year.
class RideCalenderHeader extends StatelessWidget {
  RideCalenderHeader({
    @required this.stream,
    @required this.onMonthBackward,
    @required this.onMonthForward,
  }): assert(
    stream != null && onMonthForward != null && onMonthBackward != null
  );

  final Stream<DateTime> stream;
  final void Function() onMonthForward;
  final void Function() onMonthBackward;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: stream,
      builder: (context, snapshot){
        return PlatformAwareWidget(
          android: () => _buildAndroidWidget(context, snapshot.data),
          ios: () => _buildIosWidget(context, snapshot.data),
        );
      },
    );
  }

  Widget _buildAndroidWidget(BuildContext context, DateTime date){
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: ApplicationTheme.choiceArrowIdleColor,
          splashColor: ApplicationTheme.choiceArrowOnPressedColor,
          onPressed: onMonthBackward,
        ),
        Expanded(
          child: Center(
            child: Text(DateFormat.MMMM(Localizations.localeOf(context)
                .languageCode)
                .add_y()
                .format(date),
              style: TextStyle(color: ApplicationTheme.rideCalendarHeaderColor),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          color: ApplicationTheme.choiceArrowIdleColor,
          splashColor: ApplicationTheme.choiceArrowOnPressedColor,
          onPressed: onMonthForward,
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context, DateTime date){
    return Padding(
      padding: MediaQuery.of(context).orientation == Orientation.portrait ?  const EdgeInsets.symmetric(vertical: 40,horizontal: 20): const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          CupertinoIconButton(
              icon: Icons.arrow_back_ios,
              idleColor: ApplicationTheme.choiceArrowIdleColor,
              onPressedColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: onMonthBackward
          ),
          Expanded(
            child: Center(
              child: Text(DateFormat.MMMM(Localizations.localeOf(context)
                  .languageCode)
                  .add_y()
                  .format(date),
                style: TextStyle(color: ApplicationTheme.rideCalendarHeaderColor),
              ),
            ),
          ),
          CupertinoIconButton(
              icon: Icons.arrow_forward_ios,
              idleColor: ApplicationTheme.choiceArrowIdleColor,
              onPressedColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: onMonthForward
          ),
        ],
      ),
    );
  }
}
