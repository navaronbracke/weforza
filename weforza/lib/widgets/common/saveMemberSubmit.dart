
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/saveMemberOrError.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class SaveMemberSubmit extends StatelessWidget {
  SaveMemberSubmit({
    @required this.stream,
    @required this.onPressed,
    @required this.submitButtonLabel,
    @required this.memberExistsMessage,
    @required this.genericErrorMessage,
  }): assert(
    stream != null && onPressed != null && submitButtonLabel != null
        && submitButtonLabel.isNotEmpty && memberExistsMessage != null
        && memberExistsMessage.isNotEmpty && genericErrorMessage != null
        && genericErrorMessage.isNotEmpty
  );

  final Stream<SaveMemberOrError> stream;
  final VoidCallback onPressed;
  final String submitButtonLabel;
  final String memberExistsMessage;
  final String genericErrorMessage;

  @override
  Widget build(BuildContext context){
    // Create the submit button in advance, for reuse later.
    final Widget button = PlatformAwareWidget(
      android: () => RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
            submitButtonLabel,
            style: TextStyle(color: Colors.white)
        ),
        onPressed: onPressed,
      ),
      ios: () => CupertinoButton.filled(
        child: Text(
            submitButtonLabel,
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
          return Text(genericErrorMessage);
        }else{
          if(snapshot.data.saving){
            return PlatformAwareLoadingIndicator();
          }else {
            if(snapshot.data.memberExists){
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