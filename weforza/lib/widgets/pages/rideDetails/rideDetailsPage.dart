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
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/common/memberWithPictureListItem.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeScanningStartTrigger.dart';
import 'package:weforza/widgets/pages/rideDetails/deleteRideDialog.dart';
import 'package:weforza/widgets/pages/editRide/editRidePage.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentPage.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendeesEmpty.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendeesError.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/orientationAwareWidget.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideDetailsPage extends StatefulWidget {
  @override
  _RideDetailsPageState createState() => _RideDetailsPageState(RideDetailsBloc(
      InjectionContainer.get<MemberRepository>(),
      InjectionContainer.get<RideRepository>()));
}

class _RideDetailsPageState extends State<RideDetailsPage>
    implements DeleteRideHandler {
  _RideDetailsPageState(this._bloc) : assert(_bloc != null);

  final RideDetailsBloc _bloc;

  Future<List<MemberItem>> attendeesFuture;

  @override
  void initState() {
    super.initState();
    attendeesFuture = _bloc.loadRideAttendees(RideProvider.selectedRide.date);
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
        android: () => OrientationAwareWidget(
          portrait: () => _buildAndroidPortraitLayout(context),
          landscape: () => _buildAndroidLandscapeLayout(context),
        ),
        ios: () => OrientationAwareWidget(
          portrait: () => _buildIOSPortraitLayout(context),
          landscape: () => _buildIOSLandscapeLayout(context),
        ),
      );

  Widget _buildAndroidLandscapeLayout(BuildContext context) {
    final ride = RideProvider.selectedRide;
    return Scaffold(
      appBar: AppBar(
        title: Text(ride.getFormattedDate(context, false),
            style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => RideAttendeeScanStartTrigger(
                            child: RideAttendeeAssignmentPage(
                                RideAttendeeAssignmentBloc(
                                    RideProvider.selectedRide,
                                    InjectionContainer.get<RideRepository>(),
                                    InjectionContainer.get<MemberRepository>(),
                                    InjectionContainer.get<
                                        DeviceRepository>())),
                          )))
                  .then((value) {
                if (value != null && value) {
                  setState(() {
                    attendeesFuture =
                        _bloc.loadRideAttendees(RideProvider.selectedRide.date);
                  });
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditRidePage()));
            },
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => DeleteRideDialog(this));
              }),
        ],
      ),
      body: _buildLandscapeBody(ride),
    );
  }

  Widget _buildAndroidPortraitLayout(BuildContext context) {
    final ride = RideProvider.selectedRide;
    return Scaffold(
      appBar: AppBar(
        title: Text(ride.getFormattedDate(context),
            style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => RideAttendeeScanStartTrigger(
                            child: RideAttendeeAssignmentPage(
                                RideAttendeeAssignmentBloc(
                                    RideProvider.selectedRide,
                                    InjectionContainer.get<RideRepository>(),
                                    InjectionContainer.get<MemberRepository>(),
                                    InjectionContainer.get<
                                        DeviceRepository>())),
                          )))
                  .then((value) {
                if (value != null && value) {
                  setState(() {
                    attendeesFuture =
                        _bloc.loadRideAttendees(RideProvider.selectedRide.date);
                  });
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditRidePage()));
            },
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => DeleteRideDialog(this));
              }),
        ],
      ),
      body: _buildPortraitBody(ride),
    );
  }

  Widget _buildIOSLandscapeLayout(BuildContext context) {
    final ride = RideProvider.selectedRide;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                  child: Text(ride.getFormattedDate(context, false),
                      style: TextStyle(fontSize: 16))),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton(
                    icon: Icons.person_pin,
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  RideAttendeeScanStartTrigger(
                                    child: RideAttendeeAssignmentPage(
                                        RideAttendeeAssignmentBloc(
                                            RideProvider.selectedRide,
                                            InjectionContainer.get<
                                                RideRepository>(),
                                            InjectionContainer.get<
                                                MemberRepository>(),
                                            InjectionContainer.get<
                                                DeviceRepository>())),
                                  )))
                          .then((value) {
                        if (value != null && value) {
                          setState(() {
                            attendeesFuture = _bloc.loadRideAttendees(
                                RideProvider.selectedRide.date);
                          });
                        }
                      });
                    }),
                SizedBox(width: 10),
                CupertinoIconButton(
                    icon: Icons.edit,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditRidePage()))),
                SizedBox(width: 10),
                CupertinoIconButton(
                    icon: Icons.delete,
                    onPressed: () => showCupertinoDialog(
                        context: context,
                        builder: (context) => DeleteRideDialog(this))),
              ],
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _buildLandscapeBody(ride),
      ),
    );
  }

  Widget _buildIOSPortraitLayout(BuildContext context) {
    final ride = RideProvider.selectedRide;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                  child: Text(ride.getFormattedDate(context),
                      style: TextStyle(fontSize: 16))),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton(
                    icon: Icons.person_pin,
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  RideAttendeeScanStartTrigger(
                                    child: RideAttendeeAssignmentPage(
                                        RideAttendeeAssignmentBloc(
                                            RideProvider.selectedRide,
                                            InjectionContainer.get<
                                                RideRepository>(),
                                            InjectionContainer.get<
                                                MemberRepository>(),
                                            InjectionContainer.get<
                                                DeviceRepository>())),
                                  )))
                          .then((value) {
                        if (value != null && value) {
                          setState(() {
                            attendeesFuture = _bloc.loadRideAttendees(
                                RideProvider.selectedRide.date);
                          });
                        }
                      });
                    }),
                SizedBox(width: 10),
                CupertinoIconButton(
                    icon: Icons.edit,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditRidePage()))),
                SizedBox(width: 10),
                CupertinoIconButton(
                    icon: Icons.delete,
                    onPressed: () => showCupertinoDialog(
                        context: context,
                        builder: (context) => DeleteRideDialog(this))),
              ],
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _buildPortraitBody(ride),
      ),
    );
  }

  ///Build the ride attendees list.
  Widget _buildAttendeesList() {
    return FutureBuilder<List<MemberItem>>(
      future: attendeesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return RideDetailsAttendeesError();
        } else {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return RideDetailsAttendeesEmpty();
          } else {
            return ListView.builder(
                itemBuilder: (context, index) {
                  return MemberWithPictureListItem(item: snapshot.data[index]);
                },
                itemCount: snapshot.data.length);
          }
        }
      },
    );
  }

  ///Build the panel that displays Start/Destination , Distance and Attendees count.
  Widget _buildPropertiesPanel(Ride ride) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(S.of(context).RideStart,
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(ride.startAddress ?? "-",
            softWrap: true, maxLines: 3, overflow: TextOverflow.ellipsis),
        SizedBox(height: 10),
        Text(S.of(context).RideDestination,
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(ride.destinationAddress ?? "-",
            softWrap: true, maxLines: 3, overflow: TextOverflow.ellipsis),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(ride.distance == 0.0 ? "-" : ride.distance.toString()),
                SizedBox(width: 5),
                Text(S.of(context).DistanceKm,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Expanded(child: Center()),
            StreamBuilder<String>(
              initialData: "",
              stream: _bloc.attendeesCount,
              builder: (context, snapshot) {
                if (snapshot.hasError || snapshot.data == "") {
                  return Center();
                } else {
                  return RideAttendeeCounter(count: snapshot.data);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  ///Build the page main body.
  ///Encompasses an optional title at the top,
  ///the ride properties on the left and the attendees on the right.
  Widget _buildLandscapeBody(Ride ride) {
    return (ride.title == null || ride.title.isEmpty)
        ? Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8),
                  child: _buildPropertiesPanel(ride),
                ),
              ),
              Flexible(
                flex: 4,
                child: _buildAttendeesList(),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(ride.title,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _buildPropertiesPanel(ride),
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

  ///Build the page main body.
  ///Encompasses an optional title at the top,
  ///the ride properties below the title and the attendees at the bottom.
  Widget _buildPortraitBody(Ride ride) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (ride.title == null || ride.title.isEmpty)
          ? <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: _buildPropertiesPanel(ride),
              ),
              Expanded(
                child: _buildAttendeesList(),
              ),
            ]
          : <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(ride.title,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildPropertiesPanel(ride),
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
  Future<void> deleteRide() => _bloc.deleteRide(RideProvider.selectedRide.date);
}
