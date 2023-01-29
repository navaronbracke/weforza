import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/dialogs/delete_item_dialog.dart';

/// This widget represents a dialog for deleting a rider.
class DeleteRiderDialog extends ConsumerStatefulWidget {
  const DeleteRiderDialog({super.key});

  @override
  ConsumerState<DeleteRiderDialog> createState() => _DeleteRiderDialogState();
}

class _DeleteRiderDialogState extends ConsumerState<DeleteRiderDialog> {
  Future<void>? future;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return DeleteItemDialog(
      description: translator.DeleteRiderDescription,
      errorDescription: translator.DeleteRiderErrorDescription,
      future: future,
      onDeletePressed: () {
        final notifier = ref.read(selectedRiderProvider.notifier);
        final navigator = Navigator.of(context);

        future = notifier.deleteMember().then((_) {
          if (!mounted) {
            return;
          }

          // Pop both the dialog and the rider detail screen.
          navigator.pop();
          navigator.pop();
        });

        setState(() {});
      },
      pendingDescription: translator.DeleteRiderPendingDescription,
      title: translator.DeleteRider,
    );
  }
}
