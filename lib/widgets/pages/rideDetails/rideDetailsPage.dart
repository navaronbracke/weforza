import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/export_ride_bloc.dart';
import 'package:weforza/blocs/ride_details_bloc.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/widgets/custom/dialogs/delete_item_dialog.dart';
import 'package:weforza/widgets/pages/export_ride_page.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningPage.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendees/rideDetailsAttendeesList.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/rideAttendeeProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class RideDetailsPage extends StatefulWidget {
  const RideDetailsPage({Key? key}) : super(key: key);

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
        ride: SelectedItemProvider.of(context).selectedRide.value!);
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
          style: const TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bluetooth_searching),
            onPressed: () => goToScanningPage(context),
          ),
          PopupMenuButton<RideDetailsPageOptions>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => <PopupMenuEntry<RideDetailsPageOptions>>[
              PopupMenuItem<RideDetailsPageOptions>(
                child: ListTile(
                  leading: const Icon(Icons.publish),
                  title: Text(S.of(context).Export),
                ),
                value: RideDetailsPageOptions.export,
              ),
              const PopupMenuDivider(),
              PopupMenuItem<RideDetailsPageOptions>(
                child: ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(S.of(context).Delete,
                      style: const TextStyle(color: Colors.red)),
                ),
                value: RideDetailsPageOptions.delete,
              ),
            ],
            onSelected: (RideDetailsPageOptions option) =>
                onSelectMenuOption(context, option),
          ),
        ],
      ),
      body: RideDetailsAttendeesList(
        future: bloc.attendeesFuture,
        scannedAttendees: bloc.ride.scannedAttendees,
      ),
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
                  style: const TextStyle(fontSize: 16),
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
                      icon: CupertinoIcons.ellipsis_vertical,
                      onPressed: () async {
                        final RideDetailsPageOptions? option =
                            await showCupertinoModalPopup<
                                    RideDetailsPageOptions>(
                                context: context,
                                builder: (context) {
                                  return CupertinoActionSheet(
                                    actions: [
                                      CupertinoActionSheetAction(
                                        child: Text(S.of(context).Export),
                                        onPressed: () => Navigator.of(context)
                                            .pop(RideDetailsPageOptions.export),
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text(S.of(context).Delete),
                                        isDestructiveAction: true,
                                        onPressed: () => Navigator.of(context)
                                            .pop(RideDetailsPageOptions.delete),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      child: Text(S.of(context).Cancel),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  );
                                });

                        if (option == null) return;

                        onSelectMenuOption(context, option);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: RideDetailsAttendeesList(
          future: bloc.attendeesFuture,
          scannedAttendees: bloc.ride.scannedAttendees,
        ),
      ),
    );
  }

  void goToScanningPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => RideAttendeeScanningPage(
                  fileHandler: InjectionContainer.get<IFileHandler>(),
                  onRefreshAttendees: () =>
                      RideAttendeeFutureProvider.of(context)
                          .rideAttendeeFuture
                          .value = bloc.loadRideAttendees(),
                )))
        .then((_) {
      final attendeeProvider =
          RideAttendeeFutureProvider.of(context).rideAttendeeFuture;

      callback() {
        // The attendee counters need an update too.
        if (attendeeProvider.value != null) {
          ReloadDataProvider.of(context).reloadRides.value = true;
          bloc.attendeesFuture = attendeeProvider.value!;
          attendeeProvider.value = null;
        }
      }

      // Update the UI with the new bloc.ride value.
      // Also trigger an optional refresh of the attendees.
      setState(callback);
    });
  }

  Future<void> deleteRide(BuildContext context) {
    return bloc.deleteRide().then((_) {
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
              filename: S
                  .of(context)
                  .ExportRideFileNamePlaceholder(bloc.ride.dateToDDMMYYYY()),
              ride: bloc.ride,
              rideRepository: InjectionContainer.get<RideRepository>()),
        ),
      ),
    );
  }

  void onSelectMenuOption(BuildContext context, RideDetailsPageOptions option) {
    switch (option) {
      case RideDetailsPageOptions.export:
        goToExportPage(context);
        break;
      case RideDetailsPageOptions.delete:
        builder(BuildContext context) {
          final translator = S.of(context);

          return DeleteItemDialog(
            title: translator.RideDeleteDialogTitle,
            description: translator.RideDeleteDialogDescription,
            errorDescription: translator.GenericError,
            onDelete: () => deleteRide(context),
          );
        }
        if (Platform.isAndroid) {
          showDialog(context: context, builder: builder);
        } else if (Platform.isIOS) {
          showCupertinoDialog(context: context, builder: builder);
        }
        break;

      default:
        break;
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
