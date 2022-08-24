import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/dialogs/reset_ride_calendar_dialog.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ResetRideCalendarButton extends ConsumerWidget {
  const ResetRideCalendarButton({super.key});

  Widget _buildButton(BuildContext context) {
    final translator = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlatformAwareWidget(
            android: () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ApplicationTheme.deleteItemButtonTextColor,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const ResetRideCalendarDialog(),
              ),
              child: Text(translator.ResetCalendar),
            ),
            ios: () => CupertinoButton(
              color: CupertinoColors.destructiveRed,
              onPressed: () => showCupertinoDialog(
                context: context,
                builder: (context) => const ResetRideCalendarDialog(),
              ),
              child: Text(
                translator.ResetCalendar,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          PlatformAwareWidget(
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesCount = ref.watch(rideListCountProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: ridesCount.when(
        data: (count) {
          if (count == 0) {
            return const SizedBox.shrink();
          }

          return _buildButton(context);
        },
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => const SizedBox(
          height: 48,
          child: Center(
            child: SizedBox.square(
              dimension: 48,
              child: PlatformAwareLoadingIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
