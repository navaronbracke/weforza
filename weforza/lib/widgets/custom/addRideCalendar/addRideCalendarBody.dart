//We need the body to do the following
//- support swiping left/right -> pageview
//- handle item taps -> update specific item
//- update when the header changes -> listen to current date stream, animate to page if the date changes
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';

class AddRideCalendarBody extends StatefulWidget {
  @override
  _AddRideCalendarBodyState createState() => _AddRideCalendarBodyState();
}

class _AddRideCalendarBodyState extends State<AddRideCalendarBody> {
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildCalendarRows(),
            ),
            scrollDirection: Axis.vertical,
          ),
        ),
      ],
    );
  }
}
