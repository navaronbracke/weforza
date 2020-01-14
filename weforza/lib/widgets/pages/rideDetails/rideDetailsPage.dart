import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weforza/blocs/rideDetailsBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/attendeeItem.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/pages/rideDetails/rideAttendeeItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideDetailsPage extends StatefulWidget {
  RideDetailsPage(this.ride): assert(ride != null);

  final Ride ride;

  @override
  _RideDetailsPageState createState() => _RideDetailsPageState(RideDetailsBloc(InjectionContainer.get<MemberRepository>()));
}

class _RideDetailsPageState extends State<RideDetailsPage> implements PlatformAwareWidget {
  _RideDetailsPageState(this._bloc): assert(_bloc != null);

  final RideDetailsBloc _bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat(_bloc.datePattern,Localizations.localeOf(context).languageCode).format(widget.ride.date)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete),onPressed: (){
            //TODO: delete dialog
          }),
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: (){
              //TODO: goto assignment page
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AttendeeItem>>(
        future: _bloc.getRideAttendees(widget.ride.date),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Center(child: Text(S.of(context).RideDetailsLoadAttendeesError));
          }else{
            if(snapshot.data.isEmpty){
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
    // TODO: implement buildIosWidget
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        leading: Text(DateFormat(_bloc.datePattern,Localizations.localeOf(context).languageCode).format(widget.ride.date)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoIconButton(Icons.delete,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO delete  dialog
            }),
            SizedBox(width: 10),
            CupertinoIconButton(Icons.person_pin,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO goto assignment screen
            }),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: FutureBuilder<List<AttendeeItem>>(
          future: _bloc.getRideAttendees(widget.ride.date),
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Center(child: Text(S.of(context).RideDetailsLoadAttendeesError));
            }else{
              if(snapshot.data.isEmpty){
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
}
