import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/widgets/dialogs/delete_item_dialog.dart';

class DeleteRideDialog extends ConsumerStatefulWidget {
  const DeleteRideDialog({super.key});

  @override
  ConsumerState<DeleteRideDialog> createState() => _DeleteRideDialogState();
}

class _DeleteRideDialogState extends ConsumerState<DeleteRideDialog> {
  Future<void>? future;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return DeleteItemDialog(
      description: translator.deleteRideDescription,
      errorDescription: translator.deleteRideErrorDescription,
      future: future,
      onDeletePressed: () {
        final notifier = ref.read(selectedRideProvider.notifier);
        final navigator = Navigator.of(context);

        future = notifier.deleteRide().then((_) {
          if (!mounted) {
            return;
          }

          // Pop both the dialog and the ride detail screen.
          navigator.pop();
          navigator.pop();
        });

        setState(() {});
      },
      pendingDescription: translator.deleteRidePendingDescription,
      title: translator.deleteRide,
    );
  }
}
