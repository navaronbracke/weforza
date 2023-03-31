import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';

/// This widget represents the dialog that asks for confirmation
/// to remove a scanned rider from the scan results of a ride.
class UnselectScannedRiderDialog extends StatelessWidget {
  const UnselectScannedRiderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return WeforzaAlertDialog.defaultButtons(
      confirmButtonLabel: translator.uncheck,
      description: Text(
        translator.uncheckScannedRiderDescription,
        softWrap: true,
      ),
      isDestructive: true,
      onConfirmPressed: () => Navigator.of(context).pop(true),
      title: translator.uncheckScannedRider,
    );
  }
}
