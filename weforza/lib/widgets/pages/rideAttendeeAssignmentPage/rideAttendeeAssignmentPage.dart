import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendeeAssignmentPageDisplayMode.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentGenericError.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentListEmpty.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentLoading.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanError.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning.dart';


class RideAttendeeAssignmentPage extends StatefulWidget {
  RideAttendeeAssignmentPage(this.ride): assert(ride != null);

  final Ride ride;

  @override
  _RideAttendeeAssignmentPageState createState() => _RideAttendeeAssignmentPageState(RideAttendeeAssignmentBloc());
}

class _RideAttendeeAssignmentPageState extends State<RideAttendeeAssignmentPage> {
  _RideAttendeeAssignmentPageState(this._bloc): assert(_bloc != null);

  final RideAttendeeAssignmentBloc _bloc;

  @override
  Widget build(BuildContext context){
    final String title = S.of(context).RideAttendeeAssignmentTitle(
        DateFormat(_bloc.titleDateFormat,Localizations.localeOf(context)
            .languageCode)
            .format(widget.ride.date));

    return StreamBuilder<RideAttendeeAssignmentPageDisplayMode>(
      stream: _bloc.displayMode,
      initialData: RideAttendeeAssignmentPageDisplayMode.LOADING,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return RideAttendeeAssignmentGenericError(title,S.of(context).RideAttendeeAssignmentGenericError);
        }else{
          switch(snapshot.data){
            case RideAttendeeAssignmentPageDisplayMode.IDLE:
              return _buildList(title);
            case RideAttendeeAssignmentPageDisplayMode.LOADING:
              return RideAttendeeAssignmentLoading(title);
            case RideAttendeeAssignmentPageDisplayMode.SCANNING:
              return RideAttendeeAssignmentScanning(title,_bloc);
            case RideAttendeeAssignmentPageDisplayMode.LOADING_ERROR:
              return RideAttendeeAssignmentGenericError(title,S.of(context).MemberListLoadingFailed);
            case RideAttendeeAssignmentPageDisplayMode.SCANNING_ERROR:
              return RideAttendeeAssignmentScanError(title,_bloc);
            default:
              return RideAttendeeAssignmentGenericError(title,S.of(context).RideAttendeeAssignmentGenericError);
          }
        }
      },
    );
  }

  Widget _buildList(String title){
    if(_bloc.members == null || _bloc.members.isEmpty){
      return RideAttendeeAssignmentListEmpty(title);
    }else{
      return RideAttendeeAssignmentList(_bloc.members,title,_bloc);
    }
  }
}
