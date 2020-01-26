import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideListBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/pages/addRide/addRidePage.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsPage.dart';
import 'package:weforza/widgets/pages/rideList/rideListItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/pages/rideList/rideListRidesEmpty.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] shows the list of Rides.
class RideListPage extends StatefulWidget {

  @override
  State<RideListPage> createState() => _RideListPageState(RideListBloc(InjectionContainer.get<RideRepository>()));
}

///This class is the [State] for [RideListPage].
class _RideListPageState extends State<RideListPage> implements PlatformAwareWidget {
  _RideListPageState(this._bloc): assert(_bloc != null){
    _onReload = (){
      if(RideProvider.reloadRides){
        RideProvider.reloadRides = false;
        setState(() {
          ridesFuture = _bloc.loadRides();
        });
      }
    };
  }

  final RideListBloc _bloc;

  Future<List<Ride>> ridesFuture;

  ///This callback triggers a reload.
  VoidCallback _onReload;

  @override
  void initState() {
    super.initState();
    ridesFuture = _bloc.loadRides();
  }

  @override
  Widget build(BuildContext context)=> PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).RideListRidesHeader),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage()))
                  .then((_) => _onReload()),
            ),
          ],
        ),
        body: _buildList(ridesFuture)
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(S.of(context).RideListRidesHeader)),
            ),
            CupertinoIconButton(
              Icons.add,
              CupertinoTheme.of(context).primaryColor,
              CupertinoTheme.of(context).primaryContrastingColor,
              () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage()))
                  .then((_) => _onReload()),
            ),
          ],
        ),
      ),
      child: SafeArea(
          bottom: false,
          child: _buildList(ridesFuture)
      )
    );
  }

  Widget _buildList(Future<List<Ride>> future){
    return FutureBuilder<List<Ride>>(
      future: future,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(
              child: Text(S.of(context).RideListLoadingRidesError),
            );
          }else{
            if(snapshot.data == null || snapshot.data.isEmpty){
              return RideListRidesEmpty();
            }else{
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index){
                    return RideListItem(snapshot.data[index],(){
                      RideProvider.selectedRide = snapshot.data[index];
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RideDetailsPage()))
                          .then((_) => _onReload());
                    });
                  });
            }
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }
}
