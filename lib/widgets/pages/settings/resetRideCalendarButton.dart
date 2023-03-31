import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/resetRideCalendarDialog/resetRideCalendarDialog.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ResetRideCalendarButton extends StatefulWidget {
  const ResetRideCalendarButton({Key? key}) : super(key: key);

  @override
  _ResetRideCalendarButtonState createState() =>
      _ResetRideCalendarButtonState();
}

class _ResetRideCalendarButtonState extends State<ResetRideCalendarButton> {
  // An internal flag to track the deletion.
  bool _deleted = false;

  @override
  Widget build(BuildContext context) {
    if (_deleted) return const SizedBox.shrink();

    final translator = S.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
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
                  builder: (context) => ResetRideCalendarDialog(),
                );

                if (result != null && result) {
                  setState(() {
                    _deleted = true;
                  });
                }
              },
              child: Text(translator.SettingsResetRideCalendarButtonLabel),
            ),
            ios: () => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CupertinoButton(
                  color: CupertinoColors.destructiveRed,
                  child: Text(
                    translator.SettingsResetRideCalendarButtonLabel,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final result = await showCupertinoDialog(
                      context: context,
                      builder: (context) => ResetRideCalendarDialog(),
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
                translator.SettingsResetRideCalendarDescription,
                style: ApplicationTheme
                    .settingsResetRideCalendarDescriptionTextStyle,
                textAlign: TextAlign.center,
              ),
              ios: () => Text(
                translator.SettingsResetRideCalendarDescription,
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
