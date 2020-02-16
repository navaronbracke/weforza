import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/enableBluetoothDialog.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentGenericError.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentList.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentNavigationBarContent.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeAssignmentScanning.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeScanningStartTrigger.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentSubmit/rideAttendeeAssignmentSubmit.dart';

import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeAssignmentPage extends StatefulWidget {
  RideAttendeeAssignmentPage(this.bloc): assert(bloc != null);

  final RideAttendeeAssignmentBloc bloc;

  @override
  _RideAttendeeAssignmentPageState createState() => _RideAttendeeAssignmentPageState();
}

class _RideAttendeeAssignmentPageState extends State<RideAttendeeAssignmentPage> {

  Future<List<RideAttendeeAssignmentItemBloc>> listFuture;

  Future<void> submitFuture;

  @override
  void initState() {
    super.initState();
    listFuture = widget.bloc.loadMembers();
  }

  @override
  Widget build(BuildContext context){
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIosLayout(context),
    );
  }

  Widget _buildIosLayout(BuildContext context){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: RideAttendeeAssignmentNavigationBarContent(
          title: widget.bloc.getTitle(context),
          onStartScan: () => widget.bloc.onRequestScan(
              () => showCupertinoDialog(context: context, builder: (context) => EnableBluetoothDialog())
          ),
          onSubmit: () => setState((){
            submitFuture = widget.bloc.onSubmit().then((_){
              Navigator.of(context).pop(true);
            });
          }),
          stream: widget.bloc.actionsDisplayModeStream,
        ),
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RideAttendeeAssignmentNavigationBarContent(
          title: widget.bloc.getTitle(context),
          onStartScan: () => widget.bloc.onRequestScan(
                  () => showDialog(context: context, builder: (context) => EnableBluetoothDialog())
          ),
          onSubmit: () => setState((){
            submitFuture = widget.bloc.onSubmit().then((_){
              Navigator.of(context).pop(true);
            });
          }),
          stream: widget.bloc.actionsDisplayModeStream,
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return StreamBuilder<RideAttendeeAssignmentContentDisplayMode>(
      initialData: RideAttendeeAssignmentContentDisplayMode.LIST,
      builder: (context,snapshot){
        switch(snapshot.data){
          case RideAttendeeAssignmentContentDisplayMode.LIST:
            return RideAttendeeAssignmentList(future: listFuture);
          case RideAttendeeAssignmentContentDisplayMode.SAVE:
            return RideAttendeeAssignmentSubmit(future: submitFuture);
          case RideAttendeeAssignmentContentDisplayMode.SCAN:
            return _buildScanWidget(context);
          default: return RideAttendeeAssignmentGenericError();
        }
      },
    );
  }

  Widget _buildScanWidget(BuildContext context){
    return PlatformAwareWidget(
      android: () => RideAttendeeAssignmentScanning(
        scanner: widget.bloc,
        alreadyScanningMessage: S.of(context).RideAttendeeAssignmentAlreadyScanning,
        genericScanErrorMessage: S.of(context).RideAttendeeAssignmentError,
        onScanStarted: (){
          RideAttendeeScanStartTrigger.of(context).isStarted.value = true;
        },
      ),
      ios: () => RideAttendeeAssignmentScanning(
        scanner: widget.bloc,
        alreadyScanningMessage: S.of(context).RideAttendeeAssignmentAlreadyScanning,
        genericScanErrorMessage: S.of(context).RideAttendeeAssignmentError,
        onScanStarted: (){
          RideAttendeeScanStartTrigger.of(context).isStarted.value = true;
        },
      ),
    );
  }
}

