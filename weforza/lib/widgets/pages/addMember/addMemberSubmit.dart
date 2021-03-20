
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/saveMemberOrError.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class AddMemberSubmit extends StatelessWidget {
  AddMemberSubmit({
    required this.stream,
    required this.onPressed
  });

  final Stream<SaveMemberOrError> stream;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context){
    // Create the submit button in advance, for reuse later.
    final Widget button = PlatformAwareWidget(
      android: () => ElevatedButton(
        child: Text(S.of(context).AddMemberSubmit),
        onPressed: onPressed,
      ),
      ios: () => CupertinoButton.filled(
        child: Text(
            S.of(context).AddMemberSubmit,
            style: TextStyle(color: Colors.white)
        ),
        pressedOpacity: 0.5,
        onPressed: onPressed,
      ),
    );

    return StreamBuilder<SaveMemberOrError>(
      initialData: SaveMemberOrError.idle(),
      stream: stream,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text(S.of(context).GenericError);
        }else{
          if(snapshot.data!.saving){
            return PlatformAwareLoadingIndicator();
          }else {
            if(snapshot.data!.memberExists){
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(""),
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
