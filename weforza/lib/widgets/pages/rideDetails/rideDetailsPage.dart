import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/exportRideBloc.dart';
import 'package:weforza/blocs/rideDetailsBloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/common/attendeeListCounter.dart';
import 'package:weforza/widgets/custom/deleteItemDialog/deleteItemDialog.dart';
import 'package:weforza/widgets/pages/exportRide/exportRidePage.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningPage.dart';
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

  late RideDetailsBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = RideDetailsBloc(
      memberRepo: InjectionContainer.get<MemberRepository>(),
      rideRepo: InjectionContainer.get<RideRepository>(),
      ride: SelectedItemProvider.of(context).selectedRide.value!
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
        title: Text(
            bloc.ride.getFormattedDate(context),
            style: TextStyle(fontSize: 16),
        ),
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _buildAttendeesListAttendingCount(
              context,
              bloc.attendeesFuture?.then((list)=> list.length),
            ),
          ),
          preferredSize: Size.fromHeight(10.0),
        ),
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
                  leading: Icon(Icons.publish),
                  title: Text(S.of(context).Export),
                ),
                value: RideDetailsPageOptions.EXPORT,
              ),
              PopupMenuDivider(),
              PopupMenuItem<RideDetailsPageOptions>(
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                      S.of(context).Delete,
                      style: TextStyle(color: Colors.red)
                  ),
                ),
                value: RideDetailsPageOptions.DELETE,
              ),
            ],
            onSelected: (RideDetailsPageOptions option) => onSelectMenuOption(context, option),
          ),
        ],
      ),
      body: RideDetailsAttendeesList(future: bloc.attendeesFuture),
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  bloc.ride.getFormattedDate(context),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton.fromAppTheme(
                    icon: Icons.bluetooth_searching,
                    onPressed: () => goToScanningPage(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: CupertinoIconButton.fromAppTheme(
                      icon: Icons.more_vert,
                      onPressed: () async {
                        final RideDetailsPageOptions? option = await showCupertinoModalPopup<RideDetailsPageOptions>(context: context, builder: (context){
                          return CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                child: Text(S.of(context).Export),
                                onPressed: () => Navigator.of(context).pop(RideDetailsPageOptions.EXPORT),
                              ),
                              CupertinoActionSheetAction(
                                child: Text(S.of(context).Delete),
                                isDestructiveAction: true,
                                onPressed: ()=> Navigator.of(context).pop(RideDetailsPageOptions.DELETE),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text(S.of(context).Cancel),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          );
                        });

                        if(option == null) return;

                        onSelectMenuOption(context, option);
                      }
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: _buildAttendeesListAttendingCount(
                  context,
                  bloc.attendeesFuture?.then((list)=> list.length),
                ),
              ),
            ),
            Expanded(
              child: RideDetailsAttendeesList(future: bloc.attendeesFuture),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendeesListAttendingCount(BuildContext context, Future<int>? future){
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            // When there is an error, the generic error widget is shown.
            return SizedBox.shrink();
          }else{
            final count = snapshot.data;

            // There are no attendees.
            // We show an empty list widget instead.
            if(count == null || count == 0){
              return SizedBox.shrink();
            }

            return AttendeeListCounter(count: count);
          }
        }else{
          // When the list is still loading, the loading indicator is shown.
          return SizedBox.shrink();
        }
      },
    );
  }

  void goToScanningPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RideAttendeeScanningPage(
          fileHandler: InjectionContainer.get<IFileHandler>(),
          onRefreshAttendees: () => RideAttendeeFutureProvider.of(context).rideAttendeeFuture.value = bloc.loadRideAttendees(),
        ))
    ).then((_){
      final attendeeProvider = RideAttendeeFutureProvider.of(context).rideAttendeeFuture;
      //When its not null, a new future has been submitted.
      if(attendeeProvider.value != null){
        final void Function() callback = (){
          //Also set reload for the rides, the counters need to refresh.
          ReloadDataProvider.of(context).reloadRides.value = true;
          bloc.attendeesFuture = attendeeProvider.value!;
          attendeeProvider.value = null;
        };

        setState(callback);
      }
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

  void goToExportPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ExportRidePage(
              bloc: ExportRideBloc(
                fileHandler: InjectionContainer.get<IFileHandler>(),
                filename: S.of(context).ExportRideFileNamePlaceholder(bloc.ride.dateToDDMMYYYY()),
                ride: bloc.ride,
                rideRepository: InjectionContainer.get<RideRepository>()
              ),
            ),
        ),
    );
  }

  void onSelectMenuOption(BuildContext context, RideDetailsPageOptions option){
    switch(option){
      case RideDetailsPageOptions.EXPORT:
        goToExportPage(context);
        break;
      case RideDetailsPageOptions.DELETE:
        final Widget Function(BuildContext) builder = (context) => DeleteItemDialog(
          title: S.of(context).RideDeleteDialogTitle,
          description: S.of(context).RideDeleteDialogDescription,
          errorDescription: S.of(context).GenericError,
          onDelete: () => deleteRide(context),
        );
        if(Platform.isAndroid){
          showDialog(context: context, builder: builder);
        }else if(Platform.isIOS){
          showCupertinoDialog(context: context, builder: builder);
        }
        break;

      default: break;
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
