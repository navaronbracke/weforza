import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/dialogs/reset_ride_calendar_dialog.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ResetRideCalendarButton extends StatefulWidget {
  const ResetRideCalendarButton({Key? key}) : super(key: key);

  @override
  ResetRideCalendarButtonState createState() => ResetRideCalendarButtonState();
}

class ResetRideCalendarButtonState extends State<ResetRideCalendarButton> {
  // An internal flag to track the deletion.
  bool _deleted = false;

  @override
  Widget build(BuildContext context) {
    if (_deleted) return const SizedBox.shrink();

    final translator = S.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          PlatformAwareWidget(
            android: () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ApplicationTheme.deleteItemButtonTextColor,
              ),
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (context) => const ResetRideCalendarDialog(),
                );

                if (result != null && result) {
                  setState(() {
                    _deleted = true;
                  });
                }
              },
              child: Text(translator.ResetCalendar),
            ),
            ios: () => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CupertinoButton(
                  color: CupertinoColors.destructiveRed,
                  child: Text(
                    translator.ResetCalendar,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final result = await showCupertinoDialog(
                      context: context,
                      builder: (context) => const ResetRideCalendarDialog(),
                    );

                    if (result != null && result) {
                      setState(() {
                        _deleted = true;
                      });
                    }
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PlatformAwareWidget(
              android: () => Text(
                translator.ResetCalendarDescription,
                style: ApplicationTheme
                    .settingsResetRideCalendarDescriptionTextStyle,
                textAlign: TextAlign.center,
              ),
              ios: () => Text(
                translator.ResetCalendarDescription,
                style: ApplicationTheme
                    .settingsResetRideCalendarDescriptionTextStyle
                    .copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
