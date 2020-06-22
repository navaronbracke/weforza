import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideDetailsBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/memberWithPictureListItem.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningPage.dart';
import 'package:weforza/widgets/pages/rideDetails/deleteRideDialog.dart';
import 'package:weforza/widgets/pages/editRide/editRidePage.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendeesEmpty.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendeesError.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/rideAttendeeProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class RideDetailsPage extends StatefulWidget {
  @override
  _RideDetailsPageState createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> implements DeleteRideHandler {

  RideDetailsBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = RideDetailsBloc(
      memberRepo: InjectionContainer.get<MemberRepository>(),
      rideRepo: InjectionContainer.get<RideRepository>(),
      ride: SelectedItemProvider.of(context).selectedRide.value
    );
    bloc.loadAttendeesIfNotLoaded();
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidLayout(context,bloc.ride),
    ios: () => _buildIOSLayout(context,bloc.ride),
  );

  Widget _buildAndroidLayout(BuildContext context, Ride ride) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ride.getFormattedDate(context),
            style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: () => goToScanningPage(context),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditRidePage())
              );
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
      body: _buildBody(ride),
    );
  }

  Widget _buildIOSLayout(BuildContext context, Ride ride) {
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
                    onPressedColor: ApplicationTheme.primaryColor,
                    idleColor: ApplicationTheme.accentColor,
                    icon: Icons.person_pin,
                    onPressed: () => goToScanningPage(context),
                ),
                SizedBox(width: 10),
                CupertinoIconButton(
                    onPressedColor: ApplicationTheme.primaryColor,
                    idleColor: ApplicationTheme.accentColor,
                    icon: Icons.edit,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditRidePage()))),
                SizedBox(width: 10),
                CupertinoIconButton(
                    onPressedColor: ApplicationTheme.primaryColor,
                    idleColor: ApplicationTheme.accentColor,
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
        child: _buildBody(ride),
      ),
    );
  }

  ///Build the ride attendees list.
  Widget _buildAttendeesList() {
    return FutureBuilder<List<MemberItem>>(
      future: bloc.attendeesFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
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
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
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
            RideAttendeeCounter(
              //We need the attendee names + images for displaying in the list.
              //But we need the total of people for the counter, thus we map to the length when its done loading.
              future: bloc.attendeesFuture.then((attendees) => attendees.length)
            ),
          ],
        ),
      ],
    );
  }

  ///Build the page main body.
  ///Encompasses an optional title at the top,
  ///the ride properties below the title and the attendees at the bottom.
  Widget _buildBody(Ride ride) {
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
                child: Text(
                    ride.title,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildPropertiesPanel(ride),
              ),
              Expanded(
                child: _buildAttendeesList(),
              ),
            ],
    );
  }

  void goToScanningPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RideAttendeeScanningPage(
          onRefreshAttendees: () => RideAttendeeFutureProvider.of(context).rideAttendeeFuture.value = bloc.loadRideAttendees(),
        ))
    ).then((_){
      final attendeeProvider = RideAttendeeFutureProvider.of(context).rideAttendeeFuture;
      if(attendeeProvider.value != null){
        ReloadDataProvider.of(context).reloadRides.value = true;
        setState(() => bloc.attendeesFuture = attendeeProvider.value);
        attendeeProvider.value = null;
      }
    });
  }

  @override
  Future<void> deleteRide() => bloc.deleteRide();
}
