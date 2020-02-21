import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentListLoading.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentLoadMembersError.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentNoMembers.dart';

abstract class RideAttendeeAssignmentInitializer {
  bool get isMembersLoaded;

  List<RideAttendeeAssignmentItemBloc> get loadedData;

  Future<List<RideAttendeeAssignmentItemBloc>> get loadMembersFuture;
}

class RideAttendeeAssignmentList extends StatelessWidget {
  RideAttendeeAssignmentList({@required this.dataLoader}):
        assert(dataLoader != null);

  final RideAttendeeAssignmentInitializer dataLoader;

  @override
  Widget build(BuildContext context) {
    if(dataLoader.isMembersLoaded){
      return _buildList(dataLoader.loadedData);
    }else{
      return FutureBuilder<List<RideAttendeeAssignmentItemBloc>>(
        future: dataLoader.loadMembersFuture,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return RideAttendeeAssignmentLoadMembersError();
            }else{
              final list = snapshot.data;
              return list.isEmpty ? RideAttendeeAssignmentNoMembers(): _buildList(list);
            }
          }else{
            return RideAttendeeAssignmentListLoading();
          }
        },
      );
    }
  }

  Widget _buildList(List<RideAttendeeAssignmentItemBloc> data){
    return ListView.builder(itemBuilder: (context,index){
      return RideAttendeeAssignmentListItem(bloc: data[index]);
    },itemCount: data.length);
  }
}
