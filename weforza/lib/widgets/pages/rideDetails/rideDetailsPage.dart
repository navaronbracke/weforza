import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideDetailsBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/attendeeItem.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentPage.dart';
import 'package:weforza/widgets/pages/rideDetails/deleteRideDialog.dart';
import 'package:weforza/widgets/pages/rideDetails/rideAttendeeItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideDetailsPage extends StatefulWidget {

  @override
  _RideDetailsPageState createState() => _RideDetailsPageState(RideDetailsBloc(
      InjectionContainer.get<MemberRepository>(),InjectionContainer.get<RideRepository>())
  );
}

class _RideDetailsPageState extends State<RideDetailsPage> implements PlatformAwareWidget, RideDeleteHandler {
  _RideDetailsPageState(this._bloc): assert(_bloc != null);

  final RideDetailsBloc _bloc;

  Future<List<AttendeeItem>> attendeesFuture;

  @override
  void initState() {
    super.initState();
    attendeesFuture = _bloc.loadRideAttendees(RideProvider.selectedRide.date);
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    final ride = RideProvider.selectedRide;
    return Scaffold(
      appBar: AppBar(
        title: Text(ride.getFormattedDate(context),style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RideAttendeeAssignmentPage())).then((value){
                if(value != null && value){
                  setState(() {
                    attendeesFuture = _bloc.loadRideAttendees(RideProvider.selectedRide.date);
                  });
                }
              });
            },
          ),
          IconButton(icon: Icon(Icons.delete),onPressed: (){
            showDialog(context: context, builder: (context)=> DeleteRideDialog(this));
          }),
        ],
      ),
      body: FutureBuilder<List<AttendeeItem>>(
        future: attendeesFuture,
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Center(child: Text(S.of(context).RideDetailsLoadAttendeesError));
          }else{
            if(snapshot.data == null || snapshot.data.isEmpty){
              return Center(child: Text(S.of(context).RideDetailsNoAttendees));
            }else{
              return ListView.builder(
                itemBuilder: (context,index){
                  return RideAttendeeItem(snapshot.data[index]);
                },
                itemCount: snapshot.data.length);
            }
          }
        },
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    final ride = RideProvider.selectedRide;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(ride.getFormattedDate(context),style: TextStyle(fontSize: 16))),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton(Icons.person_pin,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RideAttendeeAssignmentPage())).then((value){
                    if(value != null && value){
                      setState(() {
                        attendeesFuture = _bloc.loadRideAttendees(RideProvider.selectedRide.date);
                      });
                    }
                  });
                }),
                SizedBox(width: 30),
                CupertinoIconButton(Icons.delete,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
                  showCupertinoDialog(context: context, builder: (context)=> DeleteRideDialog(this));
                }),
              ],
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: FutureBuilder<List<AttendeeItem>>(
          future: attendeesFuture,
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Center(child: Text(S.of(context).RideDetailsLoadAttendeesError));
            }else{
              if(snapshot.data == null || snapshot.data.isEmpty){
                return Center(child: Text(S.of(context).RideDetailsNoAttendees));
              }else{
                return ListView.builder(
                    itemBuilder: (context,index){
                      return RideAttendeeItem(snapshot.data[index]);
                    },
                    itemCount: snapshot.data.length);
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Future<void> deleteRide(DateTime date) => _bloc.deleteRide(date);
}
