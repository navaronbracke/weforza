import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideDetailsBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/custom/deleteItemDialog/deleteItemDialog.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningPage.dart';
import 'package:weforza/widgets/pages/editRide/editRidePage.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendees/rideDetailsAttendeesList.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/rideAttendeeProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class RideDetailsPage extends StatefulWidget {
  @override
  _RideDetailsPageState createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {

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
    android: () => _buildAndroidLayout(context),
    ios: () => _buildIOSLayout(context),
  );

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bloc.ride.getFormattedDate(context),
            style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bluetooth_searching),
            onPressed: () => goToScanningPage(context),
          ),
          PopupMenuButton<RideDetailsPageOptions>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => <PopupMenuEntry<RideDetailsPageOptions>>[
              PopupMenuItem<RideDetailsPageOptions>(
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text(S.of(context).RideDetailsEditOption),
                ),
                value: RideDetailsPageOptions.EDIT,
              ),
              PopupMenuItem<RideDetailsPageOptions>(
                child: ListTile(
                  leading: Icon(Icons.publish),
                  title: Text(S.of(context).RideDetailsExportOption),
                ),
                value: RideDetailsPageOptions.EXPORT,
              ),
              PopupMenuDivider(),
              PopupMenuItem<RideDetailsPageOptions>(
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                      S.of(context).RideDetailsDeleteOption,
                      style: TextStyle(color: Colors.red)
                  ),
                ),
                value: RideDetailsPageOptions.DELETE,
              ),
            ],
            onSelected: (RideDetailsPageOptions option){
              switch(option){
                case RideDetailsPageOptions.EDIT:
                  goToEditPage(context);
                  break;
                case RideDetailsPageOptions.EXPORT:
                  goToExportPage(context);
                  break;
                case RideDetailsPageOptions.DELETE:
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => DeleteItemDialog(
                      title: S.of(context).RideDeleteDialogTitle,
                      description: S.of(context).RideDeleteDialogDescription,
                      errorDescription: S.of(context).RideDeleteDialogErrorDescription,
                      onDelete: () => deleteRide(context),
                    ),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: _buildBody(bloc.ride),
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                  child: Text(bloc.ride.getFormattedDate(context),
                      style: TextStyle(fontSize: 16))),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton.fromAppTheme(
                    icon: Icons.bluetooth_searching,
                    onPressed: () => goToScanningPage(context),
                ),
                SizedBox(width: 15),
                CupertinoIconButton.fromAppTheme(
                    icon: Icons.more_vert,
                    onPressed: () => showCupertinoModalPopup(context: context, builder: (context){
                      return CupertinoActionSheet(
                        actions: [
                          CupertinoActionSheetAction(
                            child: Text(S.of(context).RideDetailsEditOption),
                            onPressed: (){
                              Navigator.of(context).pop();
                              goToEditPage(context);
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text(S.of(context).RideDetailsExportOption),
                            onPressed: (){
                              Navigator.of(context).pop();
                              goToExportPage(context);
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text(S.of(context).RideDetailsDeleteOption),
                            isDestructiveAction: true,
                            onPressed: (){
                              Navigator.of(context).pop();
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => DeleteItemDialog(
                                  title: S.of(context).RideDeleteDialogTitle,
                                  description: S.of(context).RideDeleteDialogDescription,
                                  errorDescription: S.of(context).RideDeleteDialogErrorDescription,
                                  onDelete: () => deleteRide(context),
                                ),
                              );
                            },
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text(S.of(context).DialogCancel),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      );
                    })
                ),
              ],
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _buildBody(bloc.ride),
      ),
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
              future: bloc.attendeesFuture.then((attendees) => attendees.length),
              invisibleWhenLoadingOrError: true,
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
                child: RideDetailsAttendeesList(future: bloc.attendeesFuture),
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
                child: RideDetailsAttendeesList(future: bloc.attendeesFuture),
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
      //When its not null, a new future has been submitted.
      if(attendeeProvider.value != null){
        //Also set reload for the rides, the counters need to refresh.
        ReloadDataProvider.of(context).reloadRides.value = true;
        bloc.attendeesFuture = attendeeProvider.value;
        setState((){});
        attendeeProvider.value = null;
      }
    });
  }

  void goToEditPage(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditRidePage())).then((_){
      setState(() {
        bloc.ride = SelectedItemProvider.of(context).selectedRide.value;
      });
    });
  }

  Future<void> deleteRide(BuildContext context){
    return bloc.deleteRide().then((_){
      //trigger the reload of rides
      ReloadDataProvider.of(context).reloadRides.value = true;
      final navigator = Navigator.of(context);
      //Pop both the dialog and the detail screen
      navigator.pop();
      navigator.pop();
    });
  }

  void goToExportPage(BuildContext context){
    //TODO navigate to export page
  }
}
