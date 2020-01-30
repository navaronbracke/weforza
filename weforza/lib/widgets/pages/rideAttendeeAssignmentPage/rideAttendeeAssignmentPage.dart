import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';
import 'package:weforza/model/rideAttendeeDisplayMode.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentError.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentLoadMembers.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentSaving.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning.dart';

class RideAttendeeAssignmentPage extends StatelessWidget {
  RideAttendeeAssignmentPage(this._bloc): assert(_bloc != null);

  final RideAttendeeAssignmentBloc _bloc;

  @override
  Widget build(BuildContext context){
    final title = _bloc.getTitle(context);

    return StreamBuilder<RideAttendeeDisplayMode>(
      stream: _bloc.displayModeStream,
      initialData: RideAttendeeDisplayMode.MEMBERS,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return RideAttendeeAssignmentError(title);
        }else{
          switch(snapshot.data){
            case RideAttendeeDisplayMode.IDLE:
              return RideAttendeeAssignmentList(title,_bloc.items,() => _bloc.startScan(),() {
                _bloc.submitFuture = _bloc.onSubmit().then((_){
                  Navigator.of(context).pop(true);
                });
              });
            case RideAttendeeDisplayMode.MEMBERS:
              return RideAttendeeAssignmentLoadMembers(title,_bloc.loadMembers());
            case RideAttendeeDisplayMode.SCANNING:
              return RideAttendeeAssignmentScanning(_bloc.scanFuture,title,() => _bloc.stopScan());
            case RideAttendeeDisplayMode.SAVING:
              return RideAttendeeAssignmentSaving(_bloc.submitFuture,title);
            default: return RideAttendeeAssignmentError(title);
          }
        }
      },
    );
  }
}

