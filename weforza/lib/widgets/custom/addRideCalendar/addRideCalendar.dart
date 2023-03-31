import 'package:flutter/material.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarBody.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarHeader.dart';
import 'package:weforza/widgets/providers/addRideBlocProvider.dart';

class AddRideCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AddRideBlocProvider.of(context).bloc;
    return Column(children: <Widget>[
      AddRideCalenderHeader(
        stream: bloc.headerStream,
      ),
      Expanded(
        child: AddRideCalendarBody()
      ),
    ]);
  }
}