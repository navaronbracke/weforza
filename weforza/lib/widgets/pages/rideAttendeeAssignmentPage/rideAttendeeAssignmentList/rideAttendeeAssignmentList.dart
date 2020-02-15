import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentListLoading.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentLoadMembersError.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentNoMembers.dart';

class RideAttendeeAssignmentList extends StatelessWidget {
  RideAttendeeAssignmentList({@required this.future}): assert(future != null);

  final Future<List<RideAttendeeAssignmentItemBloc>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RideAttendeeAssignmentItemBloc>>(
      future: future,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return RideAttendeeAssignmentLoadMembersError();
          }else{
            final list = snapshot.data;
            if(list.isEmpty){
              return RideAttendeeAssignmentNoMembers();
            }else{
              return ListView.builder(itemBuilder: (context,index){
                return RideAttendeeAssignmentListItem(bloc: snapshot.data[index]);
              },itemCount: list.length);
            }
          }
        }else{
          return RideAttendeeAssignmentListLoading();
        }
      },
    );
  }
}
