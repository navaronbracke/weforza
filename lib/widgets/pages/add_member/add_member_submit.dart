import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/save_member_or_error.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class AddMemberSubmit extends StatelessWidget {
  const AddMemberSubmit({
    Key? key,
    required this.stream,
    required this.onPressed,
  }) : super(key: key);

  final Stream<SaveMemberOrError> stream;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Create the submit button in advance, for reuse later.
    final Widget button = PlatformAwareWidget(
      android: () => ElevatedButton(
        child: Text(S.of(context).AddMemberSubmit),
        onPressed: onPressed,
      ),
      ios: () => CupertinoButton.filled(
        child: Text(
          S.of(context).AddMemberSubmit,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    );

    return StreamBuilder<SaveMemberOrError>(
      initialData: SaveMemberOrError.idle(),
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(S.of(context).GenericError);
        } else {
          if (snapshot.data!.saving) {
            return const PlatformAwareLoadingIndicator();
          } else {
            if (snapshot.data!.memberExists) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(S.of(context).MemberAlreadyExists),
                  ),
                  button
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Show an empty text widget, to prevent popping when an already existing member is entered.
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(''),
                ),
                button
              ],
            );
          }
        }
      },
    );
  }
}
