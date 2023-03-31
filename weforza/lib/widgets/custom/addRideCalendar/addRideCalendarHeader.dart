import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///The calendar header displays a label in the center.
///This label is the current month + year.
class AddRideCalenderHeader extends StatelessWidget {
  AddRideCalenderHeader({
    @required this.stream,
    @required this.onPageBack,
    @required this.onPageForward
  }): assert(stream != null && onPageBack != null && onPageForward != null);

  final Stream<DateTime> stream;
  final VoidCallback onPageBack;
  final VoidCallback onPageForward;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: StreamBuilder<DateTime>(
        stream: stream,
        builder: (context, snapshot) => snapshot.data == null ?
          _buildPlaceholder(context) : _buildHeader(context, snapshot.data),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) => Container(height: 50);

  Widget _buildHeader(BuildContext context, DateTime date){
    return Row(
      children: <Widget>[
        PlatformAwareWidget(
          android: () => IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: ApplicationTheme.choiceArrowIdleColor,
            splashColor: ApplicationTheme.choiceArrowOnPressedColor,
            onPressed: onPageBack,
          ),
          ios: () => CupertinoIconButton(
              icon: Icons.arrow_back_ios,
              idleColor: ApplicationTheme.choiceArrowIdleColor,
              onPressedColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: onPageBack
          ),
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
        PlatformAwareWidget(
          android: () => IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            color: ApplicationTheme.choiceArrowIdleColor,
            splashColor: ApplicationTheme.choiceArrowOnPressedColor,
            onPressed: onPageForward,
          ),
          ios: () => CupertinoIconButton(
              icon: Icons.arrow_forward_ios,
              idleColor: ApplicationTheme.choiceArrowIdleColor,
              onPressedColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: onPageForward
          ),
        ),
      ],
    );
  }
}
