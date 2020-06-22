
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class AddRideSubmit extends StatelessWidget {
  AddRideSubmit(this.stream,this.onPressed):
        assert(onPressed != null && stream != null);

  final Stream<AddRideSubmitState> stream;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context){
    return StreamBuilder<AddRideSubmitState>(
      stream: stream,
      initialData: AddRideSubmitState.IDLE,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text(S.of(context).AddRideError);
        }else{
          switch(snapshot.data){
            case AddRideSubmitState.IDLE: return Column(
              children: <Widget>[
                //Show empty text widget to prevent popping
                Text(""),
                SizedBox(height: 10),
                _buildButton(context),
              ],
            );
            case AddRideSubmitState.SUBMIT: return PlatformAwareLoadingIndicator();
            case AddRideSubmitState.ERR_SUBMIT: return Text(S.of(context).AddRideError);
            case AddRideSubmitState.ERR_NO_SELECTION: return Column(
              children: <Widget>[
                Text(S.of(context).AddRideEmptySelection),
                SizedBox(height: 10),
                _buildButton(context),
              ],
            );
            default: return Text(S.of(context).AddRideError);
          }
        }
      },
    );
  }

  Widget _buildButton(BuildContext context) => PlatformAwareWidget(
    android: () => RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
            S.of(context).AddRideSubmit,
            style:TextStyle(color: Colors.white)
        ),
        onPressed: onPressed
    ),
    ios: () => CupertinoButton.filled(
      pressedOpacity: 0.5,
      child: Text(
          S.of(context).AddRideSubmit,
          softWrap: true,
          style: TextStyle(color: Colors.white)
      ),
      onPressed: onPressed,
    ),
  );
}
