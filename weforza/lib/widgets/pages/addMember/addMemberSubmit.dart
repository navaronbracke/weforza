import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/addMemberBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class AddMemberSubmit extends StatelessWidget implements PlatformAwareWidget {
  AddMemberSubmit(this.stream,this.onPressed): assert(stream != null && onPressed != null);

  final Stream<AddMemberSubmitState> stream;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context)=> PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return StreamBuilder<AddMemberSubmitState>(
      initialData: AddMemberSubmitState.IDLE,
      stream: stream,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text(S.of(context).AddMemberError);
        }else{
          switch(snapshot.data){
            case AddMemberSubmitState.IDLE: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Show an empty text widget, to prevent popping when an already existing member is entered.
                Text(""),
                SizedBox(height: 5),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(S.of(context).AddMemberSubmit, style: TextStyle(color: Colors.white)),
                  onPressed: onPressed,
                )
              ],
            );
            case AddMemberSubmitState.SUBMIT: return PlatformAwareLoadingIndicator();
            case AddMemberSubmitState.ERR_MEMBER_EXISTS: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).MemberAlreadyExists),
                SizedBox(height: 5),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(S.of(context).AddMemberSubmit, style: TextStyle(color: Colors.white)),
                  onPressed: onPressed,
                )
              ],
            );
            case AddMemberSubmitState.ERR_SUBMIT_MEMBER: return Text(S.of(context).AddMemberError);
            default: return Text(S.of(context).AddMemberError);
          }
        }
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return StreamBuilder<AddMemberSubmitState>(
      initialData: AddMemberSubmitState.IDLE,
      stream: stream,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text(S.of(context).AddMemberError);
        }else{
          switch(snapshot.data){
            case AddMemberSubmitState.IDLE: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Show an empty text widget, to prevent popping when an already existing member is entered.
                Text(""),
                SizedBox(height: 5),
                CupertinoButton.filled(
                  child: Text(S.of(context).AddMemberSubmit, style: TextStyle(color: Colors.white)),
                  pressedOpacity: 0.5,
                  onPressed: onPressed,
                )
              ],
            );
            case AddMemberSubmitState.SUBMIT: return PlatformAwareLoadingIndicator();
            case AddMemberSubmitState.ERR_MEMBER_EXISTS: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).MemberAlreadyExists),
                SizedBox(height: 5),
                CupertinoButton.filled(
                  child: Text(S.of(context).AddMemberSubmit, style: TextStyle(color: Colors.white)),
                  pressedOpacity: 0.5,
                  onPressed: onPressed,
                )
              ],
            );
            case AddMemberSubmitState.ERR_SUBMIT_MEMBER: return Text(S.of(context).AddMemberError);
            default: return Text(S.of(context).AddMemberError);
          }
        }
      },
    );
  }
}
