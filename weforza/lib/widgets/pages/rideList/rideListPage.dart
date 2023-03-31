import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideListBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/addRide/addRidePage.dart';
import 'package:weforza/widgets/pages/importExport/importAndExportPage.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsPage.dart';
import 'package:weforza/widgets/pages/rideList/rideListEmpty.dart';
import 'package:weforza/widgets/pages/rideList/rideListError.dart';
import 'package:weforza/widgets/pages/rideList/rideListItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

///This [Widget] shows the list of Rides.
class RideListPage extends StatefulWidget {

  @override
  State<RideListPage> createState() => _RideListPageState(
      bloc: RideListBloc(InjectionContainer.get<RideRepository>())
  );
}

///This class is the [State] for [RideListPage].
class _RideListPageState extends State<RideListPage> {
  _RideListPageState({@required this.bloc}): assert(bloc != null);

  final RideListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc.loadRidesIfNotLoaded();
  }

  @override
  Widget build(BuildContext context)=> PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).RideListRidesHeader),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> AddRidePage())
              ).then((_)=> onReturnToRideListPage(context)),
            ),
            IconButton(
              icon: Icon(Icons.import_export),
              color: Colors.white,
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> ImportAndExportPage())
              ).then((_)=> onReturnToRideListPage(context)),
            ),
          ],
        ),
        body: _buildList(context)
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(S.of(context).RideListRidesHeader)),
            ),
            CupertinoIconButton(
              onPressedColor: ApplicationTheme.primaryColor,
              idleColor: ApplicationTheme.accentColor,
              icon: Icons.add,
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> AddRidePage())
              ).then((_) => onReturnToRideListPage(context)),
            ),
            SizedBox(width: 10),
            CupertinoIconButton(
              onPressedColor: ApplicationTheme.primaryColor,
              idleColor: ApplicationTheme.accentColor,
              icon: Icons.import_export,
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> ImportAndExportPage())
              ).then((_) => onReturnToRideListPage(context)),
            ),
          ],
        ),
      ),
      child: SafeArea(
          bottom: false,
          child: _buildList(context)
      )
    );
  }

  Widget _buildList(BuildContext context){
    return FutureBuilder<List<Ride>>(
      future: bloc.ridesFuture,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return RideListError();
          }else{
            if(snapshot.data == null || snapshot.data.isEmpty){
              return RideListEmpty();
            }else{
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index){
                    final Ride ride = snapshot.data[index];
                    return RideListItem(
                      ride: ride,
                      rideAttendeeFuture: bloc.getAmountOfRideAttendees(ride.date),
                      onPressed: (future,ride){
                        SelectedItemProvider.of(context).selectedRide.value = ride;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RideDetailsPage(),
                          ),
                        ).then((_) => onReturnToRideListPage(context));
                      },
                    );
                  });
            }
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  void onReturnToRideListPage(BuildContext context){
    final reloadNotifier = ReloadDataProvider.of(context).reloadRides;
    if(reloadNotifier.value){
      reloadNotifier.value = false;
      setState(() {
        bloc.reloadRides();
      });
    }
  }
}
