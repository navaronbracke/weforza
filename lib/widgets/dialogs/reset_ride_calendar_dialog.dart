import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';

/// This widget represents a dialog
/// that presents the choice to remove the entire ride calendar.
class ResetRideCalendarDialog extends ConsumerStatefulWidget {
  const ResetRideCalendarDialog({super.key});

  @override
  ConsumerState<ResetRideCalendarDialog> createState() => _ResetRideCalendarDialogState();
}

class _ResetRideCalendarDialogState extends ConsumerState<ResetRideCalendarDialog> {
  Future<void>? future;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return WeforzaAsyncActionDialog(
      confirmButtonLabel: translator.reset,
      description: Text(translator.resetRideCalendarDescription, softWrap: true),
      isDestructive: true,
      errorDescription: Text(translator.resetRideCalendarErrorDescription, softWrap: true),
      future: future,
      onConfirmPressed: () {
        final repository = ref.read(rideRepositoryProvider);

        future = repository.deleteRideCalendar().then((_) {
          if (!context.mounted) {
            return;
          }

          // Refresh the rides since they have been deleted.
          // Refresh the riders since their attendances have been reset.
          ref.invalidate(rideListProvider);
          ref.invalidate(riderListProvider);

          // Close the dialog after refreshing the data.
          Navigator.of(context).pop();
        });

        setState(() {});
      },
      pendingDescription: Text(translator.resetRideCalendarPendingDescription, softWrap: true),
      title: translator.resetRideCalendar,
    );
  }
}
