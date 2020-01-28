import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';
import 'package:weforza/blocs/rideDetailsBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/memberWithPictureListItem.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentPage.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideDetailsPage extends StatefulWidget {

  @override
  _RideDetailsPageState createState() => _RideDetailsPageState(RideDetailsBloc(
      InjectionContainer.get<MemberRepository>(),InjectionContainer.get<RideRepository>())
  );
}

class _RideDetailsPageState extends State<RideDetailsPage> implements PlatformAwareWidget,PlatformAndOrientationAwareWidget {
  _RideDetailsPageState(this._bloc): assert(_bloc != null);

  final RideDetailsBloc _bloc;

  Future<List<MemberItem>> attendeesFuture;

  @override
  void initState() {
    super.initState();
    attendeesFuture = _bloc.loadRideAttendees(RideProvider.selectedRide.date);
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildAndroidPortraitLayout(context),
        buildAndroidLandscapeLayout(context)
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildIOSPortraitLayout(context),
        buildIOSLandscapeLayout(context)
    );
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    // TODO: implement buildAndroidLandscapeLayout
    final ride = RideProvider.selectedRide;
    return Scaffold(
      appBar: AppBar(
        title: Text(ride.getFormattedDate(context),style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RideAttendeeAssignmentPage(
                  RideAttendeeAssignmentBloc(
                      RideProvider.selectedRide,
                      InjectionContainer.get<RideRepository>(),
                      InjectionContainer.get<MemberRepository>()
                  )
              ))).then((value){
                if(value != null && value){
                  setState(() {
                    attendeesFuture = _bloc.loadRideAttendees(RideProvider.selectedRide.date);
                  });
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              //TODO go to edit ride
            },
          ),
          //TODO put this in edit ride as the delete button
          //IconButton(icon: Icon(Icons.delete),onPressed: (){
          //  showDialog(context: context, builder: (context)=> DeleteRideDialog(this));
          //}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Driedaagse Beernem - Halle - Zulte Driedaagse Beernem - Halle - Zulte Driedaagse Beernem - Halle - Zulte",
                softWrap: true,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(S.of(context).RideStart,style: TextStyle(fontWeight: FontWeight.bold)),
                            Icon(Icons.forward),
                            SizedBox(width: 4),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text("Dorp-West 24, 9080 Lochristi Dorp-West 24, 9080 Lochristi Dorp-West 24, 9080 Lochristi",
                            softWrap: true,maxLines: 3, overflow: TextOverflow.ellipsis
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Text(S.of(context).RideDestination,style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 4),
                            Icon(Icons.flag),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text("Kapelstraat 100, 9100 Sint-Niklaas Dorp-West 24, 9080 Lochristi Dorp-West 24, 9080 Lochristi",
                            softWrap: true,maxLines: 3, overflow: TextOverflow.ellipsis
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("9999.99"),
                                SizedBox(width: 5),
                                Text(S.of(context).DistanceKm,style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Expanded(child: Center()),
                            StreamBuilder<String>(
                              initialData: "",
                              stream: _bloc.attendeesCount,
                              builder: (context,snapshot){
                                if(snapshot.hasError || snapshot.data == ""){
                                  return Center();
                                }else{
                                  return RideAttendeeCounter(snapshot.data);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: _buildAttendeesList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildAndroidPortraitLayout(BuildContext context) {
    // TODO: implement buildAndroidPortraitLayout
    final ride = RideProvider.selectedRide;
    return Scaffold(
      appBar: AppBar(
        title: Text(ride.getFormattedDate(context),style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RideAttendeeAssignmentPage(
                  RideAttendeeAssignmentBloc(
                      RideProvider.selectedRide,
                      InjectionContainer.get<RideRepository>(),
                      InjectionContainer.get<MemberRepository>()
                  )
              ))).then((value){
                if(value != null && value){
                  setState(() {
                    attendeesFuture = _bloc.loadRideAttendees(RideProvider.selectedRide.date);
                  });
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              //TODO go to edit ride
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Driedaagse Beernem - Halle - Zulte Driedaagse Beernem - Halle - Zulte Driedaagse Beernem - Halle - Zulte",
                    softWrap: true,maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)
                ),
                SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Text(S.of(context).RideStart,style: TextStyle(fontWeight: FontWeight.bold)),
                    Icon(Icons.forward),
                    SizedBox(width: 4),
                  ],
                ),
                SizedBox(height: 4),
                Text("Dorp-West 24, 9080 Lochristi Dorp-West 24, 9080 Lochristi Dorp-West 24, 9080 Lochristi",
                    softWrap: true,maxLines: 3, overflow: TextOverflow.ellipsis
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text(S.of(context).RideDestination,style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Icon(Icons.flag),
                  ],
                ),
                SizedBox(height: 4),
                Text("Kapelstraat 100, 9100 Sint-Niklaas Dorp-West 24, 9080 Lochristi Dorp-West 24, 9080 Lochristi",
                    softWrap: true,maxLines: 3, overflow: TextOverflow.ellipsis
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("9999.99"),
                        SizedBox(width: 5),
                        Text(S.of(context).DistanceKm,style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Expanded(child: Center()),
                    StreamBuilder<String>(
                      initialData: "",
                      stream: _bloc.attendeesCount,
                      builder: (context,snapshot){
                        if(snapshot.hasError || snapshot.data == ""){
                          return Center();
                        }else{
                          return RideAttendeeCounter(snapshot.data);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildAttendeesList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIOSLandscapeLayout(BuildContext context) {
    // TODO: implement buildIOSLandscapeLayout
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RideAttendeeAssignmentPage(
                      RideAttendeeAssignmentBloc(
                          RideProvider.selectedRide,
                          InjectionContainer.get<RideRepository>(),
                          InjectionContainer.get<MemberRepository>()
                      )
                  ))).then((value){
                    if(value != null && value){
                      setState(() {
                        attendeesFuture = _bloc.loadRideAttendees(RideProvider.selectedRide.date);
                      });
                    }
                  });
                }),
                SizedBox(width: 30),
                CupertinoIconButton(
                  Icons.edit,
                  CupertinoTheme.of(context).primaryColor,
                  CupertinoTheme.of(context).primaryContrastingColor, (){
                      //TODO goto edit ride
                    },
                ),
                //TODO put this in edit ride as the delete button
                //CupertinoIconButton(Icons.delete,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
                //  showCupertinoDialog(context: context, builder: (context)=> DeleteRideDialog(this));
                //}),
              ],
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _buildAttendeesList(),
      ),
    );
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
    // TODO: implement buildIOSPortraitLayout
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RideAttendeeAssignmentPage(
                      RideAttendeeAssignmentBloc(
                          RideProvider.selectedRide,
                          InjectionContainer.get<RideRepository>(),
                          InjectionContainer.get<MemberRepository>()
                      )
                  ))).then((value){
                    if(value != null && value){
                      setState(() {
                        attendeesFuture = _bloc.loadRideAttendees(RideProvider.selectedRide.date);
                      });
                    }
                  });
                }),
                SizedBox(width: 30),
                CupertinoIconButton(
                  Icons.edit,
                  CupertinoTheme.of(context).primaryColor,
                  CupertinoTheme.of(context).primaryContrastingColor, (){
                  //TODO goto edit ride
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _buildAttendeesList(),
      ),
    );
  }

  //TODO ad this into edit widget
  //RideDeleteHandler
  //
  //@override
  //Future<void> deleteRide(DateTime date) => _bloc.deleteRide(date);

  Widget _buildAttendeesList(){
    return FutureBuilder<List<MemberItem>>(
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
                  return MemberWithPictureListItem(snapshot.data[index]);
                },
                itemCount: snapshot.data.length);
          }
        }
      },
    );
  }
}
