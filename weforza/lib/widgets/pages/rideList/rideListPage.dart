
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
  State<RideListPage> createState() => _RideListPageState(InjectionContainer.get<RideListBloc>());
}

///This class is the [State] for [RideListPage].
class _RideListPageState extends State<RideListPage> implements PlatformAwareWidget {
  _RideListPageState(this._bloc): assert(_bloc != null);

  ///The BLoC for this [Widget].
  final RideListBloc _bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(S.of(context).RideListRidesHeader),
            Expanded(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30,
                  onPressed: (){
                    //TODO Add ride for today
                    //TODO disable if already added
                  },
                ),
              ),
            ),
            Text(S.of(context).RideListAttendeesHeader),
          ],
        ),
      ),
      body: Row(
        children: <Widget>[
          Flexible(
            child: _rideListBuilder(_bloc.getAllRides(), PlatformAwareLoadingIndicator(), _RideListRidesError(), _RideListRidesEmpty())
          ),
          Flexible(
            child: _attendeesListBuilder(_bloc.getAllMembers(), PlatformAwareLoadingIndicator(), _RideListMembersError(), _RideListMembersEmpty()),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return CupertinoPageScaffold(
      child: Center(),
    );
  }

  ///This method returns a [FutureBuilder] for creating the content of the 'Rides' content area.
  ///
  ///Returns [loading] when [future] hasn't completed yet.
  ///Returns [error] when [future] completed with an error.
  ///Returns [empty] when [future] returned an empty list.
  FutureBuilder _rideListBuilder(Future<List<Ride>> future,Widget loading,
      Widget error, Widget empty){
    return FutureBuilder(
      future: future,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return error;
          }else{
            List<Ride> data = snapshot.data as List<Ride>;
            return (data == null || data.isEmpty)
                ? empty
                : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    RideItem(data[index]));
          }
        }else{
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
  FutureBuilder _attendeesListBuilder(Future<List<Member>> future,Widget loading,
      Widget error, Widget empty){
    return FutureBuilder(
      future: future,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return error;
          }else{
            List<Member> data = snapshot.data as List<Member>;
            return (data == null || data.isEmpty)
                ? empty
                : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    MemberItem(data[index]));
          }
        }else{
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

