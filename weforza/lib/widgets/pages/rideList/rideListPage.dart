import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/pages/addRide/addRidePage.dart';
import 'package:weforza/widgets/pages/rideList/rideListItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/pages/rideList/rideListRidesEmpty.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/provider/rideProvider.dart';

///This [Widget] shows the list of Rides.
class RideListPage extends StatefulWidget {

  @override
  State<RideListPage> createState() => _RideListPageState();
}

///This class is the [State] for [RideListPage].
class _RideListPageState extends State<RideListPage> implements PlatformAwareWidget {

  @override
  Widget build(BuildContext context){
    Provider.of<RideProvider>(context).loadRidesIfNotLoaded();
    return PlatformAwareWidgetBuilder.build(context, this);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    final provider = Provider.of<RideProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).RideListRidesHeader),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage())),
            ),
          ],
        ),
        body: FutureBuilder<List<Ride>>(
          future: provider.ridesFuture,
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
                      return RideListItem(snapshot.data[index]);
                    });
                }
              }
            }else{
              return Center(child: PlatformAwareLoadingIndicator());
            }
          },
        )
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    final provider = Provider.of<RideProvider>(context);
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
              () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage())),
            ),
          ],
        ),
      ),
      child: SafeArea(
          bottom: false,
          child: FutureBuilder<List<Ride>>(
            future: provider.ridesFuture,
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
                          return RideListItem(snapshot.data[index]);
                        });
                  }
                }
              }else{
                return Center(child: PlatformAwareLoadingIndicator());
              }
            },
          )
      )
    );
  }
}
