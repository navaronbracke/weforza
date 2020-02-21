import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentSubmit/rideAttendeeAssignmentSubmitError.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentSubmit/rideAttendeeAssignmentSubmitting.dart';

class RideAttendeeAssignmentSubmit extends StatelessWidget {
  RideAttendeeAssignmentSubmit({@required this.future}): assert(future != null);

  final Future<void> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasError){
          return RideAttendeeAssignmentSubmitError();
        }else{
          return RideAttendeeAssignmentSubmitting();
        }
      },
    );
  }
}
