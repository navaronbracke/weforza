import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendar.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a page where one or more rides can be added.
class AddRidePage extends StatefulWidget {
  @override
  _AddRidePageState createState() => _AddRidePageState(InjectionContainer.get<AddRideBloc>());
}

///This class is the State for [AddRidePage].
class _AddRidePageState extends State<AddRidePage> implements PlatformAwareWidget, PlatformAndOrientationAwareWidget {
  _AddRidePageState(this._bloc): assert(_bloc != null);

  ///The BLoC for this page.
  final AddRideBloc _bloc;

  //region build widget

  @override
  void initState() {
    final today = DateTime.now();
    _bloc.pageDate = DateTime(today.year,today.month);
    super.initState();
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

  //endregion

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddRideTitle),
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_bloc.errorMessage),
                  SizedBox(height: 10),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(S.of(context).AddRideSubmit,softWrap: true,style:TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if(_bloc.validateInputs(S.of(context).AddRideEmptySelection)){
                        await _bloc.addRides();
                        Navigator.pop(context);
                      }else{
                        setState(() {});
                      }
                    },
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
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 4,
            child: _buildCalendar(),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_bloc.errorMessage),
                  SizedBox(height: 10),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(S.of(context).AddRideSubmit,softWrap: true,style:TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if(_bloc.validateInputs(S.of(context).AddRideEmptySelection)){
                        await _bloc.addRides();
                        Navigator.pop(context);
                      }else{
                        setState(() {});
                      }
                    },
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
  Widget buildIOSLandscapeLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).AddRideTitle),
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_bloc.errorMessage),
                    SizedBox(height: 10),
                    CupertinoButton.filled(
                        pressedOpacity: 0.5,
                        child: Text(S.of(context).AddRideSubmit,softWrap: true,style: TextStyle(color: Colors.white)), onPressed: () async {
                      if(_bloc.validateInputs(S.of(context).AddRideEmptySelection)){
                        await _bloc.addRides();
                        Navigator.pop(context);
                      }else{
                        setState(() {});
                      }
                    }),
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
        middle: Text(S.of(context).AddRideTitle),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_bloc.errorMessage),
                    SizedBox(height: 10),
                    CupertinoButton.filled(
                        pressedOpacity: 0.5,
                        child: Text(S.of(context).AddRideSubmit,softWrap: true,style: TextStyle(color: Colors.white)), onPressed: () async {
                      if(_bloc.validateInputs(S.of(context).AddRideEmptySelection)){
                        await _bloc.addRides();
                        Navigator.pop(context);
                      }else{
                        setState(() {});
                      }
                    }),
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
      future: _bloc.loadRides(),
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
