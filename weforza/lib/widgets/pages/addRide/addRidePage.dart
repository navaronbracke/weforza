import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/pages/addRide/AddRideColorLegend.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendar.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a page where one or more rides can be added.
class AddRidePage extends StatefulWidget {
  @override
  _AddRidePageState createState() => _AddRidePageState(AddRideBloc(InjectionContainer.get<RideRepository>()));
}

///This class is the State for [AddRidePage].
class _AddRidePageState extends State<AddRidePage> implements PlatformAwareWidget, PlatformAndOrientationAwareWidget {
  _AddRidePageState(this._bloc): assert(_bloc != null);

  ///The BLoC for this page.
  final AddRideBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc.initCalendarDate();
  }

  @override
  Widget build(BuildContext context)=> PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildAndroidPortraitLayout(context),
        buildAndroidLandscapeLayout(context)
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildIOSPortraitLayout(context),
        buildIOSLandscapeLayout(context)
    );
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
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
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<String>(
                          initialData: "",
                          stream: _bloc.stream,
                          builder: (context,snapshot){
                            if(snapshot.hasError){
                              return Text(S.of(context).AddRideError);
                            }else{
                              return Text(snapshot.data);
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        StreamBuilder<bool>(
                          initialData: false,
                          builder: (context,snapshot){
                            return snapshot.data ? Center(
                              child: PlatformAwareLoadingIndicator(),
                            ): RaisedButton(
                              color: Theme.of(context).primaryColor,
                              child: Text(S.of(context).AddRideSubmit,style:TextStyle(color: Colors.white)),
                              onPressed: () async {
                                if(_bloc.validateInputs()){
                                  if(await _bloc.addRides()){
                                    RideProvider.reloadRides = true;
                                    Navigator.pop(context);
                                  }
                                }else{
                                  _bloc.addErrorMessage(S.of(context).AddRideEmptySelection);
                                }
                              },
                            );
                          },
                        ),
                      ],
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

  @override
  Widget buildAndroidPortraitLayout(BuildContext context) {
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
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<String>(
                        initialData: "",
                        stream: _bloc.stream,
                        builder: (context,snapshot){
                          if(snapshot.hasError){
                            return Text(S.of(context).AddRideError);
                          }else{
                            return Text(snapshot.data);
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      StreamBuilder<bool>(
                        initialData: false,
                        builder: (context,snapshot){
                          return snapshot.data ? Center(
                            child: PlatformAwareLoadingIndicator(),
                          ): RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: Text(S.of(context).AddRideSubmit,style:TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if(_bloc.validateInputs()){
                                if(await _bloc.addRides()){
                                  RideProvider.reloadRides = true;
                                  Navigator.pop(context);
                                }
                              }else{
                                _bloc.addErrorMessage(S.of(context).AddRideEmptySelection);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIOSLandscapeLayout(BuildContext context) {
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
                        child: Column(
                          children: <Widget>[
                            StreamBuilder<String>(
                              initialData: "",
                              stream: _bloc.stream,
                              builder: (context,snapshot){
                                if(snapshot.hasError){
                                  return Text(S.of(context).AddRideError);
                                }else{
                                  return Text(snapshot.data);
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            StreamBuilder<bool>(
                              initialData: false,
                              builder: (context,snapshot){
                                return snapshot.data ? Center(
                                  child: PlatformAwareLoadingIndicator(),
                                ): CupertinoButton.filled(
                                  pressedOpacity: 0.5,
                                  child: Text(S.of(context).AddRideSubmit,softWrap: true,style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    if(_bloc.validateInputs()){
                                      if(await _bloc.addRides()){
                                        RideProvider.reloadRides = true;
                                        Navigator.pop(context);
                                      }
                                    }else{
                                      _bloc.addErrorMessage(S.of(context).AddRideEmptySelection);
                                    }
                                  },
                                );
                              },
                            ),
                          ],
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

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
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
                      child: Column(
                        children: <Widget>[
                          StreamBuilder<String>(
                            initialData: "",
                            stream: _bloc.stream,
                            builder: (context,snapshot){
                              if(snapshot.hasError){
                                return Text(S.of(context).AddRideError);
                              }else{
                                return Text(snapshot.data);
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<bool>(
                            initialData: false,
                            builder: (context,snapshot){
                              return snapshot.data ? Center(
                                child: PlatformAwareLoadingIndicator(),
                              ): CupertinoButton.filled(
                                pressedOpacity: 0.5,
                                child: Text(S.of(context).AddRideSubmit,softWrap: true,style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  if(_bloc.validateInputs()){
                                    if(await _bloc.addRides()){
                                      RideProvider.reloadRides = true;
                                      Navigator.pop(context);
                                    }
                                  }else{
                                    _bloc.addErrorMessage(S.of(context).AddRideEmptySelection);
                                  }
                                },
                              );
                            },
                          ),
                        ],
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
