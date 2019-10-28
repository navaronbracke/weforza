import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideListBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/pages/addRide/addRidePage.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/pages/rideList/memberItem.dart';
import 'package:weforza/widgets/pages/rideList/rideItem.dart';
import 'package:weforza/widgets/pages/rideList/rideListMembersEmpty.dart';
import 'package:weforza/widgets/pages/rideList/rideListMembersError.dart';
import 'package:weforza/widgets/pages/rideList/rideListRidesEmpty.dart';
import 'package:weforza/widgets/pages/rideList/rideListRidesError.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] shows the list of Rides.
class RideListPage extends StatefulWidget {
  @override
  State<RideListPage> createState() =>
      _RideListPageState(InjectionContainer.get<RideListBloc>());
}

///This class is the [State] for [RideListPage].
class _RideListPageState extends State<RideListPage>
    implements PlatformAwareWidget, PlatformAndOrientationAwareWidget {
  _RideListPageState(this._bloc) : assert(_bloc != null);

  ///The BLoC for this [Widget].
  final RideListBloc _bloc;

  @override
  Widget build(BuildContext context) =>
      PlatformAwareWidgetBuilder.build(context, this);

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
  Widget buildAndroidPortraitLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage())),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.bluetooth_searching),
                    onPressed: () {
                      //TODO scanning
                    },
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.file_download),
                    onPressed: () {
                      //TODO import rides
                    },
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.file_upload),
                    onPressed: () {
                      //TODO export rides
                    },
                  ),
                ],
              ),
            ),
            Text(_bloc.attendingCount),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Center(), //This is a filler widget
              ),
              Row(
                children: <Widget>[
                  Text(S.of(context).RideListFilterShowAttendingOnly,
                      style: TextStyle(fontSize: 14)),
                  Switch(
                    activeTrackColor: Theme.of(context).accentColor,
                    activeColor: Colors.white,
                    value: _bloc.showAttendingOnly,
                    onChanged: (value) {
                      //TODO change filter and update list
                    },
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: _buildPageBody(),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage())),
                ),
                IconButton(
                  icon: Icon(Icons.bluetooth_searching),
                  onPressed: () {
                    //TODO scanning
                  },
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () {
                    //TODO import rides
                  },
                ),
                IconButton(
                  icon: Icon(Icons.file_upload),
                  onPressed: () {
                    //TODO export rides
                  },
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(_bloc.attendingCount),
              ),
            ),
            Row(
              children: <Widget>[
                Text(S.of(context).RideListFilterShowAttendingOnly,
                    style: TextStyle(fontSize: 14)),
                SizedBox(width: 5),
                Switch(
                  activeTrackColor: Theme.of(context).accentColor,
                  activeColor: Colors.white,
                  value: _bloc.showAttendingOnly,
                  onChanged: (value) {
                    //TODO change filter and update list
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: _buildPageBody(),
    );
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        trailing: Text(_bloc.attendingCount),
        middle: Row(
          children: <Widget>[
            CupertinoIconButton(Icons.add,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,
              () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage()))),
            SizedBox(width: 20),
            CupertinoIconButton(Icons.bluetooth_searching,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO scanning
            }),
            SizedBox(width: 20),
            CupertinoIconButton(Icons.file_download,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO import
            }),
            SizedBox(width: 20),
            CupertinoIconButton(Icons.file_upload,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO export
            }),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(),//Filler Widget
                  ),
                  Text(S.of(context).RideListFilterShowAttendingOnly,
                      style: TextStyle(fontSize: 14)),
                  CupertinoSwitch(
                    activeColor:
                        CupertinoTheme.of(context).primaryContrastingColor,
                    value: _bloc.showAttendingOnly,
                    onChanged: (value) {
                      //TODO change filter and update list
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildPageBody(),
            ),
          ],
        ),
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
            Row(
              children: <Widget>[
                CupertinoIconButton(Icons.add,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,
                        () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage()))),
                SizedBox(width: 20),
                CupertinoIconButton(Icons.bluetooth_searching,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
                  //TODO scanning
                }),
                SizedBox(width: 20),
                CupertinoIconButton(Icons.file_download,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
                  //TODO import
                }),
                SizedBox(width: 20),
                CupertinoIconButton(Icons.file_upload,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
                  //TODO export
                }),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(_bloc.attendingCount),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                children: <Widget>[
                  Text(S.of(context).RideListFilterShowAttendingOnly,
                      style: TextStyle(fontSize: 14)),
                  CupertinoSwitch(
                    activeColor:
                        CupertinoTheme.of(context).primaryContrastingColor,
                    value: _bloc.showAttendingOnly,
                    onChanged: (value) {
                      //TODO change filter and update list
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: _buildPageBody(),
      ),
    );
  }

  ///Build the main body of this page.
  Widget _buildPageBody() {
    return Row(
      children: <Widget>[
        Flexible(
            flex: 2,
            child: _rideListBuilder(
                _bloc.getAllRides(),
                PlatformAwareLoadingIndicator(),
                RideListRidesError(),
                RideListRidesEmpty())),
        Flexible(
          flex: 3,
          child: _attendeesListBuilder(
              _bloc.getAllMembers(),
              PlatformAwareLoadingIndicator(),
              RideListMembersError(),
              RideListMembersEmpty()),
        ),
      ],
    );
  }

  ///This method returns a [FutureBuilder] for creating the content of the 'Rides' content area.
  ///
  ///Returns [loading] when [future] hasn't completed yet.
  ///Returns [error] when [future] completed with an error.
  ///Returns [empty] when [future] returned an empty list.
  FutureBuilder _rideListBuilder(
      Future<List<Ride>> future, Widget loading, Widget error, Widget empty) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return error;
          } else {
            List<Ride> data = snapshot.data as List<Ride>;
            return (data == null || data.isEmpty)
                ? empty
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => RideItem(data[index]));
          }
        } else {
          return loading;
        }
      },
    );
  }

  ///This method returns a [FutureBuilder] for creating the content of the 'Attendees' content area.
  ///
  ///Returns [loading] when [future] hasn't completed yet.
  ///Returns [error] when [future] completed with an error.
  ///Returns [empty] when [future] returned an empty list.
  FutureBuilder _attendeesListBuilder(
      Future<List<Member>> future, Widget loading, Widget error, Widget empty) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return error;
          } else {
            List<Member> data = snapshot.data as List<Member>;
            return (data == null || data.isEmpty)
                ? empty
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => MemberItem(data[index]));
          }
        } else {
          return loading;
        }
      },
    );
  }
}
