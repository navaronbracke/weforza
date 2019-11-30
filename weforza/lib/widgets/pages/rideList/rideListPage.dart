import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideListBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/rideAttendeeItemModel.dart';
import 'package:weforza/model/rideItemModel.dart';
import 'package:weforza/widgets/pages/addRide/addRidePage.dart';
import 'package:weforza/widgets/pages/rideList/rideListAttendeeFilter.dart';
import 'package:weforza/widgets/pages/rideList/rideListSelector.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/pages/rideList/memberItem.dart';
import 'package:weforza/widgets/pages/rideList/rideItem.dart';
import 'package:weforza/widgets/pages/rideList/rideListMembersEmpty.dart';
import 'package:weforza/widgets/pages/rideList/rideListRidesEmpty.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] shows the list of Rides.
class RideListPage extends StatefulWidget {
  @override
  State<RideListPage> createState() =>
      _RideListPageState(InjectionContainer.get<RideListBloc>());
}

///This class is the [State] for [RideListPage].
class _RideListPageState extends State<RideListPage>
    implements PlatformAwareWidget, PlatformAndOrientationAwareWidget, IRideSelector, IRideAttendeeSelector, AttendeeFilterHandler {
  _RideListPageState(this._bloc) : assert(_bloc != null);

  ///The BLoC for this [Widget].
  final RideListBloc _bloc;

  ///The future that loads the rides.
  Future<List<RideItemModel>> loadRidesFuture;

  ///The future that loads the attendees.
  Future<List<RideAttendeeItemModel>> loadAttendeesFuture;

  @override
  void initState() {
    super.initState();
    loadRidesFuture = _bloc.getRides();
    loadAttendeesFuture = _bloc.getAllMembers();
  }

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
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage())).then((value){
                setState(() {
                  _bloc.resetSelectionMode();
                  loadRidesFuture = _bloc.getRides();
                  loadAttendeesFuture = _bloc.getAllMembers();
                });
              }),
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
              icon: Icon(Icons.import_export),
              onPressed: () {
                //TODO import/export rides
              },
            ),
            Expanded(
              child: Center(
                child: Visibility(
                  visible: _bloc.selectionMode == RideSelectionMode.NORMAL,
                  child: StreamBuilder<String>(
                    stream: _bloc.attendeeCount,
                    initialData: "",
                    builder: (context,snapshot){
                      return snapshot.hasError ? Text("") : Text(snapshot.data);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Visibility(
            visible: _bloc.selectionMode == RideSelectionMode.NORMAL,
            child: Row(
              children: <Widget>[
                Text(S.of(context).RideListAttendeesHeader,
                    style: TextStyle(fontSize: 14)),
                RideListAttendeeFilter(_bloc.filterState,this),
              ],
            ),
          ),
        ],
      ),
      body: _buildPageBody()
    );
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage())).then((value){
                  setState(() {
                    _bloc.resetSelectionMode();
                    loadRidesFuture = _bloc.getRides();
                    loadAttendeesFuture = _bloc.getAllMembers();
                  });
                }),
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
                icon: Icon(Icons.import_export),
                onPressed: () {
                  //TODO import/export rides
                },
              ),
              Expanded(
                child: Center(
                  child: Visibility(
                    visible: _bloc.selectionMode == RideSelectionMode.NORMAL,
                    child: StreamBuilder<String>(
                      stream: _bloc.attendeeCount,
                      initialData: "",
                      builder: (context,snapshot){
                        return snapshot.hasError ? Text("") : Text(snapshot.data);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Visibility(
              visible: _bloc.selectionMode == RideSelectionMode.NORMAL,
              child: Row(
                children: <Widget>[
                  Text(S.of(context).RideListAttendeesHeader,
                      style: TextStyle(fontSize: 14)),
                  RideListAttendeeFilter(_bloc.filterState,this),
                ],
              ),
            ),
          ],
        ),
        body: _buildPageBody()
    );
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            CupertinoIconButton(Icons.add,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage())).then((value){
                setState(() {
                  _bloc.resetSelectionMode();
                  loadRidesFuture = _bloc.getRides();
                  loadAttendeesFuture = _bloc.getAllMembers();
                });
              }),
            ),
            SizedBox(width: 20),
            CupertinoIconButton(Icons.bluetooth_searching,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO scanning
            }),
            SizedBox(width: 20),
            CupertinoIconButton(Icons.import_export,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO import and export rides
            }),
            Expanded(
              child: Visibility(
                visible: _bloc.selectionMode == RideSelectionMode.NORMAL,
                child: Center(
                  child: StreamBuilder<String>(
                    stream: _bloc.attendeeCount,
                    initialData: "",
                    builder: (context,snapshot){
                      return snapshot.hasError ? Text("") : Text(snapshot.data);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: Visibility(
          visible: _bloc.selectionMode == RideSelectionMode.NORMAL,
          child: Row(
            children: <Widget>[
              Text(S.of(context).RideListAttendeesHeader,
                  style: TextStyle(fontSize: 14)),
              RideListAttendeeFilter(_bloc.filterState,this),
            ],
          ),
        ),
      ),
      child: SafeArea(
        child: _buildPageBody()
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
            CupertinoIconButton(Icons.add,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddRidePage())).then((value){
                setState(() {
                  _bloc.resetSelectionMode();
                  loadRidesFuture = _bloc.getRides();
                  loadAttendeesFuture = _bloc.getAllMembers();
                });
              }),
            ),
            SizedBox(width: 20),
            CupertinoIconButton(Icons.bluetooth_searching,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO scanning
            }),
            SizedBox(width: 20),
            CupertinoIconButton(Icons.import_export,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO import and export rides
            }),
            Expanded(
              child: Visibility(
                visible: _bloc.selectionMode == RideSelectionMode.NORMAL,
                child: Center(
                  child: StreamBuilder<String>(
                    stream: _bloc.attendeeCount,
                    initialData: "",
                    builder: (context,snapshot){
                      return snapshot.hasError ? Text("") : Text(snapshot.data);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: Visibility(
          visible: _bloc.selectionMode == RideSelectionMode.NORMAL,
          child: Row(
            children: <Widget>[
              Text(S.of(context).RideListAttendeesHeader,
                  style: TextStyle(fontSize: 14)),
              RideListAttendeeFilter(_bloc.filterState,this),
            ],
          ),
        ),
      ),
      child: SafeArea(
          child: _buildPageBody()
      ),
    );
  }

  ///Build the main body of this page.
  Widget _buildPageBody() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: FutureBuilder(
            future: loadRidesFuture,
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return Center(child: Text(S.of(context).RideListLoadingRidesError));
                }else{
                  return _buildRidesList(snapshot.data as List<RideItemModel>);
                }
              }else{
                return Center(child: PlatformAwareLoadingIndicator());
              }
            },
          ),
        ),
        Flexible(
          flex: 3,
          child: StreamBuilder<PanelDisplayMode>(
            stream: _bloc.displayStream,
            initialData: PanelDisplayMode.ATTENDEES,
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Center(
                  child: Text(S.of(context).RideListPanelDisplayError,softWrap: true),
                );
              }else{
                switch(snapshot.data){
                  case PanelDisplayMode.ATTENDEES: return _buildAttendeesPanel();
                  case PanelDisplayMode.RIDE_DELETION: return _buildDeleteRidesPanel();
                  case PanelDisplayMode.BLUETOOTH: return _buildBluetoothScanningPanel();
                }
                return Center();
              }
            },
          ),
        ),
      ],
    );
  }


  Widget _buildRidesList(List<RideItemModel> items) {
    return items.isEmpty ? RideListRidesEmpty() : ListView.builder(itemCount: items.length,
        itemBuilder: (context, index) => RideItem(items[index].bloc,this));
  }

  Widget _buildAttendeesList(List<RideAttendeeItemModel> items) {
    return items.isEmpty ? RideListMembersEmpty(_bloc.filterState == AttendeeFilterState.ON) : ListView.builder(itemCount: items.length,itemBuilder:
        (context, index) => MemberItem(items[index].bloc,this));
  }

  Widget _buildAttendeesPanel(){
    return FutureBuilder(
      future: loadAttendeesFuture,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(child: Text(S.of(context).RideListLoadingMembersError));
          }else{
            return _buildAttendeesList(snapshot.data as List<RideAttendeeItemModel>);
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  Widget _buildDeleteRidesPanel(){
    return Center(
      child: Text("Delete Ride Panel here"),
    );
    //TODO
  }

  Widget _buildBluetoothScanningPanel(){
    return Center(
      child: Text("Bluetooth Panel here"),
    );
    //TODO
  }

  @override
  void selectAttendee(IRideAttendeeSelectable item) async {
    if(_bloc.selectionMode == RideSelectionMode.NORMAL){
      await _bloc.selectAttendee(item);
      setState(() {});
    }
  }

  @override
  void selectRide(IRideSelectable item){
    setState(() {
      _bloc.selectRide(item);
      if(_bloc.selectionMode == RideSelectionMode.NORMAL){
        switch(_bloc.filterState){
          case AttendeeFilterState.DISABLED: loadAttendeesFuture = _bloc.getAllMembers(); break;
          case AttendeeFilterState.OFF: loadAttendeesFuture = _bloc.getAllMembersWithAttendingSelected(); break;
          case AttendeeFilterState.ON: loadAttendeesFuture = _bloc.getAttendeesOnly(); break;
        }
      }
    });
  }

  @override
  void turnOnFilter() {
    setState(() {
      _bloc.filterState = AttendeeFilterState.ON;
      loadAttendeesFuture = _bloc.getAttendeesOnly();
    });
  }

  @override
  void turnOffFilter() {
    setState(() {
      _bloc.filterState = AttendeeFilterState.OFF;
      loadAttendeesFuture = _bloc.getAllMembersWithAttendingSelected();
    });
  }

  @override
  void enableDeleteMode() => _bloc.enableDeletionMode();

  @override
  bool get isDeleteMode => _bloc.selectionMode == RideSelectionMode.DELETION;
}
