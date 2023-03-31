import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendar.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarColorLegend.dart';
import 'package:weforza/widgets/pages/addRide/addRideSubmit.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/addRideBlocProvider.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';

///This [Widget] represents a page where one or more rides can be added.
class AddRidePage extends StatefulWidget {
  @override
  _AddRidePageState createState() => _AddRidePageState(
      bloc: AddRideBloc(repository: InjectionContainer.get<RideRepository>())
  );
}

///This class is the State for [AddRidePage].
class _AddRidePageState extends State<AddRidePage> {
  _AddRidePageState({@required this.bloc}): assert(bloc != null);

  ///The BLoC for this page.
  final AddRideBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc.initCalendarDate();
    bloc.loadRideDatesIfNotLoaded();
  }

  @override
  Widget build(BuildContext context)=> PlatformAwareWidget(
    android: () => _buildAndroidLayout(context),
    ios: () => _buildIOSLayout(context),
  );

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddRideTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () => bloc.onRequestClear(),
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
                  child: AddRideCalendarColorLegend(),
                ),
                Expanded(
                  child: Center(
                    child: AddRideSubmit(bloc.submitStream,() async {
                      await bloc.addRides().then((_){
                        ReloadDataProvider.of(context).reloadRides.value = true;
                        Navigator.pop(context);
                      }).catchError((e){
                        //do nothing with the error
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

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(S.of(context).AddRideTitle)),
            ),
            CupertinoIconButton(
              onPressedColor: ApplicationTheme.primaryColor,
              idleColor: ApplicationTheme.accentColor,
              icon: Icons.delete_sweep,
              onPressed: () => bloc.onRequestClear(),
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
                      child: AddRideCalendarColorLegend(),
                    ),
                    Expanded(
                      child: Center(
                        child: AddRideSubmit(bloc.submitStream,() async {
                          await bloc.addRides().then((_){
                            ReloadDataProvider.of(context).reloadRides.value = true;
                            Navigator.pop(context);
                          }).catchError((e){
                            //do nothing with the error
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
    return FutureBuilder<void>(
      future: bloc.loadExistingRidesFuture,
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(
                child: Text(S.of(context).AddRideLoadingFailed),
              );
            }
            else{
              return AddRideBlocProvider(
                bloc: bloc, child: AddRideCalendar()
              );
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
    bloc.dispose();
    super.dispose();
  }
}
