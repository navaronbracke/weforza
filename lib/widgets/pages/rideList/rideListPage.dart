import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/ride_list_bloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/addRide/addRidePage.dart';
import 'package:weforza/widgets/pages/exportRides/exportRidesPage.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsPage.dart';
import 'package:weforza/widgets/pages/rideList/rideListEmpty.dart';
import 'package:weforza/widgets/pages/rideList/rideListItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

///This [Widget] shows the list of Rides.
class RideListPage extends StatefulWidget {
  const RideListPage({Key? key}) : super(key: key);

  @override
  State<RideListPage> createState() => _RideListPageState(
      bloc: RideListBloc(InjectionContainer.get<RideRepository>()));
}

///This class is the [State] for [RideListPage].
class _RideListPageState extends State<RideListPage> {
  _RideListPageState({required this.bloc});

  final RideListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc.loadRidesIfNotLoaded();
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
        android: () => _buildAndroidWidget(context),
        ios: () => _buildIosWidget(context),
      );

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).Rides),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const AddRidePage()))
                  .then((_) => onReturnToRideListPage(context)),
            ),
            IconButton(
              icon: const Icon(Icons.file_upload),
              color: Colors.white,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ExportRidesPage())),
            ),
          ],
        ),
        body: _buildList(context));
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(S.of(context).Rides),
                ),
              ),
              CupertinoIconButton.fromAppTheme(
                icon: CupertinoIcons.add,
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const AddRidePage()))
                    .then((_) => onReturnToRideListPage(context)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: CupertinoIconButton.fromAppTheme(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ExportRidesPage())),
                  icon: CupertinoIcons.arrow_up_doc_fill,
                ),
              ),
            ],
          ),
        ),
        child: SafeArea(bottom: false, child: _buildList(context)));
  }

  Widget _buildList(BuildContext context) {
    return FutureBuilder<List<Ride>>(
      future: bloc.ridesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return GenericError(text: S.of(context).GenericError);
          } else {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const RideListEmpty();
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final Ride ride = snapshot.data![index];

                    return RideListItem(
                      ride: ride,
                      rideAttendeeFuture:
                          bloc.getAmountOfRideAttendees(ride.date),
                      onPressed: (future, ride) {
                        SelectedItemProvider.of(context).selectedRide.value =
                            ride;
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => const RideDetailsPage(),
                              ),
                            )
                            .then((_) => onReturnToRideListPage(context));
                      },
                    );
                  });
            }
          }
        } else {
          return const Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  void onReturnToRideListPage(BuildContext context) {
    final reloadNotifier = ReloadDataProvider.of(context).reloadRides;
    if (reloadNotifier.value) {
      reloadNotifier.value = false;
      setState(() {
        bloc.reloadRides();
      });
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
