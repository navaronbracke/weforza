import 'package:flutter/material.dart';
import 'package:weforza/blocs/add_ride_bloc.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarBody.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarHeader.dart';

class AddRideCalendar extends StatelessWidget {
  const AddRideCalendar({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  final AddRideBloc bloc;

  // TODO: Fix the responseive design on small screens.
  // The calendar items should be slightly smaller.
  // The font size for the days should be smaller.
  // The pageview height constraint should be smaller.

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
