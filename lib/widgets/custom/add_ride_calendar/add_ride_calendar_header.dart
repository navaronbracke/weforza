import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

///The calendar header displays a label in the center.
///This label is the current month + year.
class AddRideCalenderHeader extends StatelessWidget {
  const AddRideCalenderHeader({
    Key? key,
    required this.stream,
    required this.onPageBack,
    required this.onPageForward,
  }) : super(key: key);

  final Stream<DateTime> stream;
  final VoidCallback onPageBack;
  final VoidCallback onPageForward;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: StreamBuilder<DateTime>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return _buildPlaceholder(context);
          }

          return _buildHeader(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) => Container(height: 50);

  Widget _buildHeader(BuildContext context, DateTime date) {
    return Row(
      children: <Widget>[
        PlatformAwareWidget(
          android: () => IconButton(
            icon: const Icon(Icons.arrow_back),
            color: ApplicationTheme.choiceArrowIdleColor,
            splashColor: ApplicationTheme.choiceArrowOnPressedColor,
            onPressed: onPageBack,
          ),
          ios: () => Padding(
            // The left chevron is more to the left.
            padding: const EdgeInsets.only(left: 8),
            child: CupertinoIconButton.fromAppTheme(
              icon: Icons.arrow_back_ios,
              onPressed: onPageBack,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              DateFormat.MMMM(Localizations.localeOf(context).languageCode)
                  .add_y()
                  .format(date),
              style: const TextStyle(
                  color: ApplicationTheme.rideCalendarHeaderColor),
            ),
          ),
        ),
        PlatformAwareWidget(
          android: () => IconButton(
            icon: const Icon(Icons.arrow_forward),
            color: ApplicationTheme.choiceArrowIdleColor,
            splashColor: ApplicationTheme.choiceArrowOnPressedColor,
            onPressed: onPageForward,
          ),
          ios: () => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: CupertinoIconButton.fromAppTheme(
              icon: Icons.arrow_forward_ios,
              onPressed: onPageForward,
            ),
          ),
        ),
      ],
    );
  }
}
