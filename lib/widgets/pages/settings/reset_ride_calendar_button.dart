import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/dialogs/reset_ride_calendar_dialog.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ResetRideCalendarButton extends ConsumerWidget {
  const ResetRideCalendarButton({super.key});

  Widget _buildButton(BuildContext context, {bool enabled = true}) {
    final translator = S.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlatformAwareWidget(
          android: () => ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: ApplicationTheme.deleteItemButtonTextColor,
            ),
            onPressed: enabled
                ? () => showDialog(
                      context: context,
                      builder: (_) => const ResetRideCalendarDialog(),
                    )
                : null,
            child: Text(translator.ResetRideCalendar),
          ),
          ios: () => CupertinoButton(
            color: CupertinoColors.destructiveRed,
            onPressed: enabled
                ? () => showCupertinoDialog(
                      context: context,
                      builder: (context) => const ResetRideCalendarDialog(),
                    )
                : null,
            child: Text(
              translator.ResetRideCalendar,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        PlatformAwareWidget(
          android: () => Text(
            translator.ResetRideCalendarDescription,
            style:
                ApplicationTheme.settingsResetRideCalendarDescriptionTextStyle,
            textAlign: TextAlign.center,
          ),
          ios: () => Text(
            translator.ResetRideCalendarDescription,
            style: ApplicationTheme
                .settingsResetRideCalendarDescriptionTextStyle
                .copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesCount = ref.watch(rideListCountProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
      child: ridesCount.when(
        data: (count) => _buildButton(context, enabled: count > 0),
        error: (error, stackTrace) => _buildButton(context, enabled: false),
        loading: () => _buildButton(context, enabled: false),
      ),
    );
  }
}
