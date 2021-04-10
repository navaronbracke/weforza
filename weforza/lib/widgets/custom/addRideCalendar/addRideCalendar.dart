import 'package:flutter/material.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarBody.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarHeader.dart';

class AddRideCalendar extends StatelessWidget {
  AddRideCalendar({
    required this.bloc,
  });

  final AddRideBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AddRideCalenderHeader(
          stream: bloc.headerStream,
          onPageBack: bloc.onPageBackward,
          onPageForward: bloc.onPageForward,
        ),
        AddRideCalendarBody(bloc: bloc),
      ],
    );
  }
}