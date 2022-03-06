import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/saveMemberOrError.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class SaveMemberSubmit extends StatelessWidget {
  SaveMemberSubmit({
    Key? key,
    required this.stream,
    required this.onPressed,
    required this.submitButtonLabel,
    required this.memberExistsMessage,
    required this.genericErrorMessage,
  })  : assert(submitButtonLabel.isNotEmpty &&
            memberExistsMessage.isNotEmpty &&
            genericErrorMessage.isNotEmpty),
        super(key: key);

  final Stream<SaveMemberOrError> stream;
  final VoidCallback onPressed;
  final String submitButtonLabel;
  final String memberExistsMessage;
  final String genericErrorMessage;

  @override
  Widget build(BuildContext context) {
    // Create the submit button in advance, for reuse later.
    final Widget button = PlatformAwareWidget(
      android: () => ElevatedButton(
        child: Text(submitButtonLabel),
        onPressed: onPressed,
      ),
      ios: () => CupertinoButton.filled(
        child: Text(
          submitButtonLabel,
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
          return Text(genericErrorMessage);
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
                    child: Text(memberExistsMessage),
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
