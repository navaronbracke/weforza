import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'file:///E:/Documenten/WeForza/weforza/weforza/lib/widgets/custom/enableBluetoothDialog/enableBluetoothDialog.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentGenericError.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentList.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentNavigationBarContent.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeAssignmentScanning.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeAssignmentScanningError.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeAssignmentScanningLoadDevices.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeAssignmentScanningProcessingResult.dart';
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

  Future<void> submitFuture;

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => await widget.bloc.stopScanAndProcessResults(),
      child: PlatformAwareWidget(
        android: () => _buildAndroidLayout(context),
        ios: () => _buildIosLayout(context),
      ),
    );
  }

  Widget _buildIosLayout(BuildContext context){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: RideAttendeeAssignmentNavigationBarContent(
          scanTitle: S.of(context).RideAttendeeAssignmentScanningTitle,
          title: S.of(context).RideAttendeeAssignmentTitle,
          onStartScan: () => widget.bloc.startScan(
              () => showCupertinoDialog(context: context, builder: (context) => EnableBluetoothDialog()),
                  ()=> RideAttendeeScanStartTrigger.of(context).isStarted.value = true
          ),
          onSubmit: () => setState((){
            submitFuture = widget.bloc.onSubmit().then((_){
              Navigator.of(context).pop(true);
            });
          }),
          stream: widget.bloc.navigationBarStream,
        ),
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RideAttendeeAssignmentNavigationBarContent(
          scanTitle: S.of(context).RideAttendeeAssignmentScanningTitle,
          title: S.of(context).RideAttendeeAssignmentTitle,
          onStartScan: () => widget.bloc.startScan(
                  () => showDialog(context: context, builder: (context) => EnableBluetoothDialog()),
                  ()=> RideAttendeeScanStartTrigger.of(context).isStarted.value = true
          ),
          onSubmit: () => setState((){
            submitFuture = widget.bloc.onSubmit().then((_){
              Navigator.of(context).pop(true);
            });
          }),
          stream: widget.bloc.navigationBarStream,
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return StreamBuilder<RideAttendeeAssignmentContentDisplayMode>(
      stream: widget.bloc.contentDisplayModeStream,
      initialData: RideAttendeeAssignmentContentDisplayMode.LIST,
      builder: (context,snapshot){
        switch(snapshot.data){
          case RideAttendeeAssignmentContentDisplayMode.LIST:
            return RideAttendeeAssignmentList(dataLoader: widget.bloc);
          case RideAttendeeAssignmentContentDisplayMode.SAVE:
            return RideAttendeeAssignmentSubmit(future: submitFuture);
          case RideAttendeeAssignmentContentDisplayMode.SCAN:
            return RideAttendeeAssignmentScanning(
              duration: widget.bloc.scanDuration,
              onStopScan: () => widget.bloc.stopScan(),
              deviceStream: widget.bloc.foundDevices,
            );
          case RideAttendeeAssignmentContentDisplayMode.PROCESS:
            return RideAttendeeAssignmentScanningProcessingResult();
          case RideAttendeeAssignmentContentDisplayMode.ERR_ALREADY_SCANNING:
            return RideAttendeeAssignmentScanningError(
              message: S.of(context).RideAttendeeAssignmentAlreadyScanning,
              onPressed: () => widget.bloc.stopScan(),
            );
          case RideAttendeeAssignmentContentDisplayMode.LOAD_DEVICES:
            return  RideAttendeeAssignmentScanningLoadDevices();
          default: return RideAttendeeAssignmentGenericError();
        }
      },
    );
  }
}

