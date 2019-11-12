
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/blocs/addRideCalendarItemBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarItem.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarPaginator.dart';

///This class is the [Widget] for the AddRide calendar body.
class AddRideCalendarBody extends StatefulWidget {
  AddRideCalendarBody(Key key,this.bloc,this.paginator): assert(bloc != null && paginator != null && key != null),super(key: key);

  final AddRideBloc bloc;
  final IAddRideCalendarPaginator paginator;

  @override
  _AddRideCalendarBodyState createState() => _AddRideCalendarBodyState();
}

class _AddRideCalendarBodyState extends State<AddRideCalendarBody> implements IRideDayScheduler {

  List<AddRideCalendarItemBloc> itemBlocs = List();

  @override
  void initState() {
    super.initState();
    widget.bloc.onSelectionCleared = (){
      itemBlocs.forEach((child) => child.reset());
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(child: Center(child: Text(S.of(context).MondayPrefix,textAlign: TextAlign.center))),
            Flexible(child: Center(child: Text(S.of(context).TuesdayPrefix,textAlign: TextAlign.center))),
            Flexible(child: Center(child: Text(S.of(context).WednesdayPrefix,textAlign: TextAlign.center))),
            Flexible(child: Center(child: Text(S.of(context).ThursdayPrefix,textAlign: TextAlign.center))),
            Flexible(child: Center(child: Text(S.of(context).FridayPrefix,textAlign: TextAlign.center))),
            Flexible(child: Center(child: Text(S.of(context).SaturdayPrefix,textAlign: TextAlign.center))),
            Flexible(child: Center(child: Text(S.of(context).SundayPrefix,textAlign: TextAlign.center))),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildCalendarRows(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCalendarRows(){
    DateTime pageDate = widget.paginator.pageDate;
    //Calculate the start offset
    //If the first day of the month is monday, this is 0. If this day is a sunday, its 6.
    int offset = pageDate.weekday - 1;
    //A list of filler widgets for the offset + the actual day widgets
    List<Widget> items = List();
    //Add start offset widgets first
    for(int i = 0; i<offset; i++){
      items.add(SizedBox(width: 30, height: 30));
    }
    //Add days of month
    int daysInMonth = widget.paginator.daysInMonth;
    itemBlocs.clear();
    for(int i = 0; i< daysInMonth; i++){
      final bloc = AddRideCalendarItemBloc(DateTime(pageDate.year,pageDate.month,i+1), this);
      final item = AddRideCalendarItem(bloc);
      items.add(item);
      itemBlocs.add(bloc);
    }
    //Calculate the end offset
    //if the last day of the displayed month is a sunday, this is 0. If it is a monday it is 6.
    offset = 7 - DateTime(pageDate.year,pageDate.month,daysInMonth).weekday;
    //Add end offset widgets last
    for(int i = 0; i<offset; i++){
      items.add(SizedBox(width: 30, height: 30));
    }

    //The aforementioned items, but grouped in rows
    List<Widget> output = List();

    //While we still have items to put in rows, generate a row
    while(items.isNotEmpty){
      List<Widget> children = List();
      if(items.length < 7){
        //Add remaining items
        while(items.isNotEmpty){
          children.add(items.removeAt(0));
        }
      }else{
        //Add a week range
        for(int i = 0; i< 7; i++){
          children.add(items.removeAt(0));
        }
      }
      Row row = Row(children: children,mainAxisAlignment: MainAxisAlignment.spaceAround);
      output.add(Padding(
        child: row,
        padding: EdgeInsets.fromLTRB(0, 5,0,5),
      ));
    }
    return output;
  }

  @override
  bool hasRidePlanned(DateTime date) => widget.bloc.dayHasRidePlanned(date);

  @override
  bool isNewlyScheduledRide(DateTime date) => widget.bloc.dayIsNewlyScheduledRide(date);

  @override
  bool onDayPressed(DateTime date) => widget.bloc.onDayPressed(date);
}