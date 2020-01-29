import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';
import 'package:weforza/blocs/rideDetailsBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/common/memberWithPictureListItem.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/pages/rideDetails/deleteRideDialog.dart';
import 'package:weforza/widgets/pages/editRide/editRidePage.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentPage.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideDetailsPage extends StatefulWidget {

  @override
  _RideDetailsPageState createState() => _RideDetailsPageState(RideDetailsBloc(
      InjectionContainer.get<MemberRepository>(),InjectionContainer.get<RideRepository>())
  );
}

class _RideDetailsPageState extends State<RideDetailsPage> implements PlatformAwareWidget,PlatformAndOrientationAwareWidget, RideDeleteHandler {
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
    final ride = RideProvider.selectedRide;
    return Scaffold(
      appBar: AppBar(
        title: Text(ride.getFormattedDate(context,false),style: TextStyle(fontSize: 16)),
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditRidePage())).then((value){
                if(value != null && value){
                  setState(() {});
                }
              });
            },
          ),
          IconButton(icon: Icon(Icons.delete),onPressed: (){
            showDialog(context: context, builder: (context)=> DeleteRideDialog(this));
          }),
        ],
      ),
      body: ride.title == null ? _buildBodyWithoutTitle(ride) : _buildBodyWithTitle(ride)
    );
  }

  @override
  Widget buildAndroidPortraitLayout(BuildContext context) {
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditRidePage())).then((value){
                if(value != null && value){
                  setState(() {});
                }
              });
            },
          ),
          IconButton(icon: Icon(Icons.delete),onPressed: (){
            showDialog(context: context, builder: (context)=> DeleteRideDialog(this));
          }),
        ],
      ),
      body: ride.title == null ? _buildBodyWithoutTitle(ride) : _buildBodyWithTitle(ride)
    );
  }

  @override
  Widget buildIOSLandscapeLayout(BuildContext context) {
    final ride = RideProvider.selectedRide;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(ride.getFormattedDate(context,false),style: TextStyle(fontSize: 16))),
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
                SizedBox(width: 10),
                CupertinoIconButton(
                  Icons.edit,
                  CupertinoTheme.of(context).primaryColor,
                  CupertinoTheme.of(context).primaryContrastingColor, (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditRidePage())).then((value){
                    if(value != null && value){
                      setState(() {});
                    }
                  });
                }),
                SizedBox(width: 10),
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
        child: ride.title == null ? _buildBodyWithoutTitle(ride) : _buildBodyWithTitle(ride)
      ),
    );
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
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
                SizedBox(width: 10),
                CupertinoIconButton(
                    Icons.edit,
                    CupertinoTheme.of(context).primaryColor,
                    CupertinoTheme.of(context).primaryContrastingColor, (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditRidePage())).then((value){
                    if(value != null && value){
                      setState(() {});
                    }
                  });
                }),
                SizedBox(width: 10),
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
        child: ride.title == null ? _buildBodyWithoutTitle(ride) : _buildBodyWithTitle(ride)
      ),
    );
  }

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

  Widget _buildBodyWithTitle(Ride ride){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(ride.title,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)
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
                      Text(
                          ride.startAddress ?? "-",
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis
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
                      Text(
                          ride.destinationAddress ?? "-",
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(ride.distance == 0.0 ? "-" : ride.distance.toString()),
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
    );
  }

  Widget _buildBodyWithoutTitle(Ride ride){
    return Row(
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
                Text(
                    ride.startAddress ?? "-",
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis
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
                Text(
                    ride.destinationAddress ?? "-",
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(ride.distance == 0.0 ? "-" : ride.distance.toString()),
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
    );
  }

  @override
  Future<void> deleteRide(DateTime date) => _bloc.deleteRide(date);
}
