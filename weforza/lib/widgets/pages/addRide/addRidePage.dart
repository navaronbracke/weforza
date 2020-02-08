import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/pages/addRide/addRideColorLegend.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendar.dart';
import 'package:weforza/widgets/pages/addRide/addRideSubmit.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/orientationAwareWidget.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a page where one or more rides can be added.
class AddRidePage extends StatefulWidget {
  @override
  _AddRidePageState createState() => _AddRidePageState(AddRideBloc(InjectionContainer.get<RideRepository>()));
}

///This class is the State for [AddRidePage].
class _AddRidePageState extends State<AddRidePage> {
  _AddRidePageState(this._bloc): assert(_bloc != null);

  ///The BLoC for this page.
  final AddRideBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc.initCalendarDate();
  }

  @override
  Widget build(BuildContext context)=> PlatformAwareWidget(
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
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddRideTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () => _bloc.onRequestClear(),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 3,
              child: _buildCalendar(),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: AddRideColorLegend(),
                  ),
                  Expanded(
                    child: Center(
                      child: AddRideSubmit(_bloc.submitStream,() async {
                        await _bloc.addRides((){
                          RideProvider.reloadRides = true;
                          Navigator.pop(context);
                        });
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidPortraitLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddRideTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () => _bloc.onRequestClear(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: _buildCalendar(),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: AddRideColorLegend(),
                ),
                Expanded(
                  child: Center(
                    child: AddRideSubmit(_bloc.submitStream,() async {
                      await _bloc.addRides((){
                        RideProvider.reloadRides = true;
                        Navigator.pop(context);
                      });
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIOSLandscapeLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(S.of(context).AddRideTitle)),
            ),
            CupertinoIconButton(
              Icons.delete_sweep,
              CupertinoTheme.of(context).primaryColor,
              CupertinoTheme.of(context).primaryContrastingColor, () => _bloc.onRequestClear()
            ),
          ],
        ),
      ),
      child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: _buildCalendar(),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: AddRideColorLegend(),
                      ),
                      Expanded(
                        child: Center(
                          child: AddRideSubmit(_bloc.submitStream,() async {
                            await _bloc.addRides((){
                              RideProvider.reloadRides = true;
                              Navigator.pop(context);
                            });
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIOSPortraitLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(S.of(context).AddRideTitle)),
            ),
            CupertinoIconButton(
              Icons.delete_sweep,
              CupertinoTheme.of(context).primaryColor,
              CupertinoTheme.of(context).primaryContrastingColor, () => _bloc.onRequestClear()
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              flex:4,
              child: _buildCalendar(),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: AddRideColorLegend(),
                    ),
                    Expanded(
                      child: Center(
                        child: AddRideSubmit(_bloc.submitStream,() async {
                          await _bloc.addRides((){
                            RideProvider.reloadRides = true;
                            Navigator.pop(context);
                          });
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Build the calendar.
  Widget _buildCalendar(){
    return FutureBuilder(
      future: _bloc.loadRideDates(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(
                child: Text(S.of(context).AddRideLoadingFailed),
              );
            }
            else{
              return AddRideCalendar(_bloc);
            }
          }else {
            return Center(
              child: PlatformAwareLoadingIndicator(),
            );
          }
        }
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
