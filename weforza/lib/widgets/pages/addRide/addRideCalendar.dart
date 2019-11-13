
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarBody.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarHeader.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarPaginator.dart';

class AddRideCalendar extends StatefulWidget {
  AddRideCalendar(this.bloc): assert(bloc != null);

  final AddRideBloc bloc;

  @override
  _AddRideCalendarState createState() => _AddRideCalendarState();
}

class _AddRideCalendarState extends State<AddRideCalendar> implements IAddRideCalendarPaginator {

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AddRideCalendarHeader(this),
      Expanded(child: AddRideCalendarBody(ValueKey<DateTime>(widget.bloc.pageDate),widget.bloc,this)),
    ]);
  }

  @override
  int get daysInMonth => widget.bloc.daysInMonth;

  @override
  DateTime get pageDate => widget.bloc.pageDate;

  @override
  void pageForward() {
    setState(() {
      widget.bloc.addMonth();
    });
  }

  @override
  void pageBack() {
    setState(() {
      widget.bloc.subtractMonth();
    });
  }
}
