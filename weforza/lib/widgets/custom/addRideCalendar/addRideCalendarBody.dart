import 'package:flutter/material.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/custom/addRideCalendar/addRideCalendarMonth.dart';

class AddRideCalendarBody extends StatelessWidget {
  AddRideCalendarBody({
    required this.bloc,
  });

  final AddRideBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Center(
                child: Text(
                  S.of(context).MondayPrefix,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  S.of(context).TuesdayPrefix,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  S.of(context).WednesdayPrefix,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  S.of(context).ThursdayPrefix,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  S.of(context).FridayPrefix,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  S.of(context).SaturdayPrefix,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  S.of(context).SundayPrefix,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onHorizontalDragEnd: bloc.onDragCalendar,
          child: SizedBox(
            height: 320,
            child: PageView.builder(
              controller: bloc.pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bloc.calendarItemCount,
              itemBuilder: (context, index) => AddRideCalendarMonth(
                pageDate: bloc.pageDate,
                daysInMonth: bloc.daysInMonth,
                key: ValueKey<DateTime>(bloc.pageDate),
                isBeforeToday: bloc.isBeforeToday,
                onTap: bloc.onDayPressed,
                rideScheduledOn: bloc.rideScheduledOn,
                rideScheduledDuringCurrentSession: bloc.rideScheduledDuringCurrentSession,
                register: bloc.registerResetFunction,
                unregister: bloc.unregisterResetFunction,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
