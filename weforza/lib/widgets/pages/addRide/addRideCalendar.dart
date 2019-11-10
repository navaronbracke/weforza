
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarBody.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarHeader.dart';

class AddRideCalendar extends StatefulWidget {
  AddRideCalendar(this.bloc): assert(bloc != null);

  final AddRideBloc bloc;

  @override
  _AddRideCalendarState createState() => _AddRideCalendarState();
}

class _AddRideCalendarState extends State<AddRideCalendar> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AddRideCalendarHeader(widget.bloc),
        Expanded(
          child: AddRideCalendarBody(),
        ),
      ],
    );
  }
}
