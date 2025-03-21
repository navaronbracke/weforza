import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/widgets/dialogs/reset_ride_calendar_dialog.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

class ResetRideCalendarButton extends ConsumerWidget {
  const ResetRideCalendarButton({super.key});

  void _showResetCalendarDialog(BuildContext context) {
    showAdaptiveDialog<void>(context: context, builder: (_) => const ResetRideCalendarDialog());
  }

  Widget _buildButton(BuildContext context, {bool enabled = true}) {
    return PlatformAwareWidget(
      android: (context) {
        final styles = Theme.of(context).extension<DestructiveButtons>()!;

        return ElevatedButton(
          style: styles.elevatedButtonStyle,
          onPressed: enabled ? () => _showResetCalendarDialog(context) : null,
          child: Text(S.of(context).resetRideCalendar),
        );
      },
      ios: (context) {
        return CupertinoButton(
          borderRadius: BorderRadius.zero,
          padding: EdgeInsets.zero,
          onPressed: enabled ? () => _showResetCalendarDialog(context) : null,
          child: Text(
            S.of(context).resetRideCalendar,
            style: enabled ? const TextStyle(color: CupertinoColors.destructiveRed) : null,
          ),
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
