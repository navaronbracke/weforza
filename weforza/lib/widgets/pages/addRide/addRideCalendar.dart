
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

  Widget _calendarBody;
  Widget _calendarHeader;

  @override
  void initState() {
    super.initState();
    _calendarHeader = AddRideCalendarHeader(this);
    _calendarBody = AddRideCalendarBody(this,widget.bloc);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      _calendarHeader,
      Expanded(child: _calendarBody),
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
      _calendarHeader = AddRideCalendarHeader(this);
      _calendarBody = AddRideCalendarBody(this,widget.bloc);
    });
  }

  @override
  void pageBack() {
    setState(() {
      widget.bloc.subtractMonth();
      _calendarHeader = AddRideCalendarHeader(this);
      _calendarBody = AddRideCalendarBody(this,widget.bloc);
    });
  }
}
