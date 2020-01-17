import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';


class RideAttendeeAssignmentPage extends StatefulWidget {
  RideAttendeeAssignmentPage(this.ride): assert(ride != null);

  final Ride ride;

  @override
  _RideAttendeeAssignmentPageState createState() => _RideAttendeeAssignmentPageState(RideAttendeeAssignmentBloc());
}

class _RideAttendeeAssignmentPageState extends State<RideAttendeeAssignmentPage> implements PlatformAwareWidget {
  _RideAttendeeAssignmentPageState(this._bloc): assert(_bloc != null);

  final RideAttendeeAssignmentBloc _bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).RideAttendeeAssignmentTitle(DateFormat(_bloc.titleDateFormat,Localizations.localeOf(context)
            .languageCode).format(widget.ride.date))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: (){
              //TODO update streambuilder and start scanning
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Center(child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(S.of(context).RideAttendeeAssignmentInstruction),
          )),
          Expanded(
            child: ListView.builder(
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text("$index"),
                  );
                },itemCount: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return null;
  }
}
