import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/custom/dialogs/delete_item_dialog.dart';

class DeleteMemberDialog extends ConsumerStatefulWidget {
  const DeleteMemberDialog({Key? key}) : super(key: key);

  @override
  _DeleteMemberDialogState createState() => _DeleteMemberDialogState();
}

class _DeleteMemberDialogState extends ConsumerState<DeleteMemberDialog> {
  Future<void>? future;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return DeleteItemDialog(
      title: translator.DeleteRider,
      description: translator.MemberDeleteDialogDescription,
      errorDescription: translator.GenericError,
      future: future,
      onDeletePressed: () {
        final notifier = ref.read(selectedMemberProvider.notifier);

        future = notifier.deleteMember().then((_) {
          if (!mounted) {
            return;
          }

          final navigator = Navigator.of(context);
          // Pop both the dialog and the detail screen.
          navigator.pop();
          navigator.pop();
        });

        setState(() {});
      },
    );
  }
}
