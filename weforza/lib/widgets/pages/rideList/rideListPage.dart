import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideListBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/loadingIndicator.dart';
import 'package:weforza/widgets/pages/rideList/memberItem.dart';
import 'package:weforza/widgets/pages/rideList/rideItem.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] shows the list of Rides.
class RideListPage extends StatefulWidget {
  @override
  State<RideListPage> createState() =>
      _RideListPageState(InjectionContainer.get<RideListBloc>());
}

///This class is the [State] for [RideListPage].
class _RideListPageState extends State<RideListPage>
    implements PlatformAwareWidget {
  _RideListPageState(this._bloc) : assert(_bloc != null);

  ///The BLoC for this [Widget].
  final RideListBloc _bloc;

  @override
  Widget build(BuildContext context) =>
      PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildAndroidPortraitLayout(context);
        } else {
          return _buildAndroidLandscapeLayout(context);
        }
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildIOSPortraitLayout(context);
        } else {
          return _buildIOSLandscapeLayout(context);
        }
      },
    );
  }

  ///This method builds the portrait layout for Android.
  Widget _buildAndroidPortraitLayout(BuildContext context) {
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
                    onPressed: () {
                      //TODO Add ride for today
                      //TODO disable if already added
                    },
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

  ///This method builds the landscape layout for Android.
  Widget _buildAndroidLandscapeLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    //TODO Add ride for today
                    //TODO disable if already added
                  },
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

  ///This method builds the portrait layout for IOS.
  Widget _buildIOSPortraitLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        trailing: Text(_bloc.attendingCount),
        middle: Row(
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.add),
              onTap: () {
                //TODO add ride for today if not added yet
              },
            ),
            SizedBox(width: 20),
            GestureDetector(
              child: Icon(Icons.bluetooth_searching),
              onTap: () {
                //TODO scanning
              },
            ),
            SizedBox(width: 20),
            GestureDetector(
              child: Icon(Icons.file_download),
              onTap: () {
                //TODO import
              },
            ),
            SizedBox(width: 20),
            GestureDetector(
              child: Icon(Icons.file_upload),
              onTap: () {
                //TODO export
              },
            ),
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

  ///This method builds the landscape layout for IOS.
  Widget _buildIOSLandscapeLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.add),
                  onTap: () {
                    //TODO add ride for today if not added yet
                  },
                ),
                SizedBox(width: 20),
                GestureDetector(
                  child: Icon(Icons.bluetooth_searching),
                  onTap: () {
                    //TODO scanning
                  },
                ),
                SizedBox(width: 20),
                GestureDetector(
                  child: Icon(Icons.file_download),
                  onTap: () {
                    //TODO import
                  },
                ),
                SizedBox(width: 20),
                GestureDetector(
                  child: Icon(Icons.file_upload),
                  onTap: () {
                    //TODO export
                  },
                ),
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
                _RideListRidesError(),
                _RideListRidesEmpty())),
        Flexible(
          flex: 3,
          child: _attendeesListBuilder(
              _bloc.getAllMembers(),
              PlatformAwareLoadingIndicator(),
              _RideListMembersError(),
              _RideListMembersEmpty()),
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

///This class represents an empty list [Widget] for the 'Rides' section of [RideListPage].
class _RideListRidesEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(S.of(context).RideListNoRides),
          SizedBox(height: 5),
          Text(S.of(context).RideListAddRideInstruction),
        ],
      ),
    );
  }
}

///This class represents an empty list [Widget] for the 'Members' section of [RideListPage].
class _RideListMembersEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(S.of(context).RideListNoMembers),
          SizedBox(height: 5),
          Text(S.of(context).RideListAddMemberInstruction),
        ],
      ),
    );
  }
}

///This class represents an error [Widget] for the 'Rides' section of [RideListPage].
class _RideListRidesError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(S.of(context).RideListLoadingRidesFailed),
    );
  }
}

///This class represents an error [Widget] for the 'Members' section of [RideListPage].
class _RideListMembersError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(S.of(context).RideListLoadingMembersFailed),
    );
  }
}
