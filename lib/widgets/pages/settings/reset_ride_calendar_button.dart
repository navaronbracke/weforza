import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/widgets/custom/dialogs/reset_ride_calendar_dialog.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

class ResetRideCalendarButton extends ConsumerWidget {
  const ResetRideCalendarButton({super.key});

  Widget _buildButton(BuildContext context, {bool enabled = true}) {
    return PlatformAwareWidget(
      android: () => ElevatedButton(
        style: AppTheme.desctructiveAction.elevatedButtonTheme,
        onPressed: enabled
            ? () => showDialog(
                  context: context,
                  builder: (_) => const ResetRideCalendarDialog(),
                )
            : null,
        child: Text(S.of(context).ResetRideCalendar),
      ),
      ios: () {
        if (enabled) {
          return CupertinoButton(
            borderRadius: BorderRadius.zero,
            onPressed: () => showCupertinoDialog(
              context: context,
              builder: (context) => const ResetRideCalendarDialog(),
            ),
            padding: EdgeInsets.zero,
            child: Text(
              S.of(context).ResetRideCalendar,
              style: const TextStyle(color: CupertinoColors.destructiveRed),
            ),
          );
        }

        return CupertinoButton(
          borderRadius: BorderRadius.zero,
          onPressed: null,
          padding: EdgeInsets.zero,
          child: Text(S.of(context).ResetRideCalendar),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesCount = ref.watch(rideListCountProvider);

    return ridesCount.when(
      data: (count) => _buildButton(context, enabled: count > 0),
      error: (error, stackTrace) => _buildButton(context, enabled: false),
      loading: () => _buildButton(context, enabled: false),
    );
  }
}
