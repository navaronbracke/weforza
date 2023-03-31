import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/widgets/custom/dialogs/delete_item_dialog.dart';

class DeleteRideDialog extends ConsumerStatefulWidget {
  const DeleteRideDialog({super.key});

  @override
  DeleteRideDialogState createState() => DeleteRideDialogState();
}

class DeleteRideDialogState extends ConsumerState<DeleteRideDialog> {
  Future<void>? future;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return DeleteItemDialog(
      title: translator.DeleteRide,
      description: translator.RideDeleteDialogDescription,
      errorDescription: translator.GenericError,
      future: future,
      onDeletePressed: () {
        final notifier = ref.read(selectedRideProvider.notifier);

        future = notifier.deleteRide().then<void>((_) {
          if (!mounted) {
            return;
          }

          final navigator = Navigator.of(context);
          // Pop both the dialog and the detail screen.
          navigator.pop();
          navigator.pop();
        }).catchError((error) => Future.error(error));

        setState(() {});
      },
    );
  }
}
