
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarMonth.dart';
import 'package:weforza/widgets/providers/addRideBlocProvider.dart';

class AddRideCalendarBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AddRideBlocProvider.of(context).bloc;
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
          child: PageView.builder(
            controller: bloc.pageController,
            itemBuilder: (context, index) => AddRideCalendarMonth(
              pageDate: bloc.pageDate,
              daysInMonth: bloc.daysInMonth,
              key: ValueKey<DateTime>(bloc.pageDate),
            ),
            itemCount: bloc.calendarItemCount,
          ),
        ),
      ],
    );
  }
}

