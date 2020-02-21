
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/editMemberBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class EditMemberSubmit extends StatelessWidget {
  EditMemberSubmit(this.stream,this.onPressed)
      : assert(stream != null && onPressed != null);

  final Stream<EditMemberSubmitState> stream;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context)=> PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return StreamBuilder<EditMemberSubmitState>(
      initialData: EditMemberSubmitState.IDLE,
      stream: stream,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text(S.of(context).EditMemberError);
        }else{
          switch(snapshot.data){
            case EditMemberSubmitState.IDLE: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Show an empty text widget, to prevent popping when an already existing member is entered.
                Text(""),
                SizedBox(height: 5),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(S.of(context).EditMemberSubmit, style: TextStyle(color: Colors.white)),
                  onPressed: onPressed,
                )
              ],
            );
            case EditMemberSubmitState.SUBMIT: return PlatformAwareLoadingIndicator();
            case EditMemberSubmitState.MEMBER_EXISTS: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).MemberAlreadyExists),
                SizedBox(height: 5),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(S.of(context).EditMemberSubmit, style: TextStyle(color: Colors.white)),
                  onPressed: onPressed,
                )
              ],
            );
            default: return Text(S.of(context).EditMemberError);
          }
        }
      },
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return StreamBuilder<EditMemberSubmitState>(
      initialData: EditMemberSubmitState.IDLE,
      stream: stream,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text(S.of(context).EditMemberError);
        }else{
          switch(snapshot.data){
            case EditMemberSubmitState.IDLE: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Show an empty text widget, to prevent popping when an already existing member is entered.
                Text(""),
                SizedBox(height: 5),
                CupertinoButton(
                  child: Text(S.of(context).EditMemberSubmit),
                  pressedOpacity: 0.5,
                  onPressed: onPressed,
                )
              ],
            );
            case EditMemberSubmitState.SUBMIT: return PlatformAwareLoadingIndicator();
            case EditMemberSubmitState.MEMBER_EXISTS: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).MemberAlreadyExists),
                SizedBox(height: 5),
                CupertinoButton(
                  child: Text(S.of(context).EditMemberSubmit),
                  pressedOpacity: 0.5,
                  onPressed: onPressed,
                )
              ],
            );
            default: return Text(S.of(context).EditMemberError);
          }
        }
      },
    );
  }
}
