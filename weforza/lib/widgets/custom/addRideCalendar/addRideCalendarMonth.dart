import 'package:flutter/material.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarItem.dart';

class AddRideCalendarMonth extends StatelessWidget {
  AddRideCalendarMonth({
    @required this.pageDate,
    @required this.daysInMonth,
    @required ValueKey<DateTime> key,
  }): assert(pageDate != null && daysInMonth != null), super(key: key);

  final DateTime pageDate;
  final int daysInMonth;

  @override
  Widget build(BuildContext context) => Column(children: _buildCalendarRows());

  List<Widget> _buildCalendarRows(){
    //Calculate the start offset
    //If the first day of the month is monday, this is 0. If this day is a sunday, its 6.
    int offset = pageDate.weekday - 1;
    //A list of filler widgets for the offset + the actual day widgets
    List<Widget> items = [];
    //Add start offset widgets first
    for(int i = 0; i<offset; i++){
      items.add(SizedBox.fromSize(size: Size.square(40)));
    }

    //Add days of month
    for(int i = 0; i< daysInMonth; i++){
      final item = AddRideCalendarItem(date: DateTime(pageDate.year,pageDate.month,i+1));
      items.add(item);
    }
    //Calculate the end offset
    //if the last day of the displayed month is a sunday, this is 0. If it is a monday it is 6.
    offset = 7 - DateTime(pageDate.year,pageDate.month,daysInMonth).weekday;
    //Add end offset widgets last
    for(int i = 0; i<offset; i++){
      items.add(SizedBox.fromSize(size: Size.square(40)));
    }

    //The aforementioned items, but grouped in rows
    List<Widget> output = [];

    //While we still have items to put in rows, generate a row
    while(items.isNotEmpty){
      List<Widget> children = [];
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
      Row row = Row(children: children, mainAxisAlignment: MainAxisAlignment.spaceAround);
      output.add(Padding(
        child: row,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      ));
    }
    return output;
  }
}
