
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] is the submit section of AddRidePage.
class AddRideSubmit extends StatefulWidget {
  final AddRideBloc bloc;

  AddRideSubmit(this.bloc): assert(bloc != null);

  @override
  _AddRideSubmitState createState() => _AddRideSubmitState();
}

class _AddRideSubmitState extends State<AddRideSubmit> implements PlatformAwareWidget {
  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.bloc.errorMessage),
        SizedBox(height: 10),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(S.of(context).AddRideSubmit,softWrap: true,style:TextStyle(color: Colors.white)),
          onPressed: () async {
            if(widget.bloc.validateInputs(S.of(context).AddRideEmptySelection)){
              await widget.bloc.addRides();
              //pass true to indicate a reload
              Navigator.pop(context,true);
            }else{
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.bloc.errorMessage),
        SizedBox(height: 10),
        CupertinoButton.filled(
          pressedOpacity: 0.5,
          child: Text(S.of(context).AddRideSubmit,softWrap: true,style: TextStyle(color: Colors.white)),
            onPressed: () async {
              if (widget.bloc.validateInputs(S.of(context).AddRideEmptySelection)) {
                await widget.bloc.addRides();
                Navigator.pop(context);
              } else {
                setState(() {});
              }
            }
        ),
      ],
    );
  }


}
