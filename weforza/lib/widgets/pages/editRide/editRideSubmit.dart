import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/editRideBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class EditRideSubmit extends StatelessWidget {
  EditRideSubmit(this.stream,this.onPressed):
        assert(stream != null && onPressed != null);

  final Stream<EditRideSubmitState> stream;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );
  
  Widget _buildAndroidWidget(BuildContext context) {
    return StreamBuilder<EditRideSubmitState>(
      stream: stream,
      initialData: EditRideSubmitState.IDLE,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text(S.of(context).EditRideSubmitError);
        }else{
          switch(snapshot.data){
            case EditRideSubmitState.IDLE: return RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(S.of(context).EditRideSubmit, style: TextStyle(color: Colors.white)),
              onPressed: onPressed,
            );
            case EditRideSubmitState.SUBMIT: return PlatformAwareLoadingIndicator();
            default: return Text(S.of(context).EditRideSubmitError);
          }
        }
      },
    );
  }
  
  Widget _buildIosWidget(BuildContext context) {
    return StreamBuilder<EditRideSubmitState>(
      stream: stream,
      initialData: EditRideSubmitState.IDLE,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text(S.of(context).EditRideSubmitError);
        }else{
          switch(snapshot.data){
            case EditRideSubmitState.IDLE: return CupertinoButton(
              child: Text(S.of(context).EditRideSubmit),
              pressedOpacity: 0.5,
              onPressed: onPressed,
            );
            case EditRideSubmitState.SUBMIT: return PlatformAwareLoadingIndicator();
            default: return Text(S.of(context).EditRideSubmitError);
          }
        }
      },
    );
  }
}
