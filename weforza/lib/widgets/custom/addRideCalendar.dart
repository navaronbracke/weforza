
import 'package:calendarro/calendarro.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';

///This [Widget] represents a Calendar for picking Ride dates.
class AddRideCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Calendarro(
      displayMode: DisplayMode.MONTHS,
      selectionMode: SelectionMode.MULTI,
      weekdayLabelsRow: Row(
        children: <Widget>[
          Expanded(child: Text(S.of(context).MondayPrefix, textAlign: TextAlign.center)),
          Expanded(child: Text(S.of(context).TuesdayPrefix, textAlign: TextAlign.center)),
          Expanded(child: Text(S.of(context).WednesdayPrefix, textAlign: TextAlign.center)),
          Expanded(child: Text(S.of(context).ThursdayPrefix, textAlign: TextAlign.center)),
          Expanded(child: Text(S.of(context).FridayPrefix, textAlign: TextAlign.center)),
          Expanded(child: Text(S.of(context).SaturdayPrefix, textAlign: TextAlign.center)),
          Expanded(child: Text(S.of(context).SundayPrefix, textAlign: TextAlign.center)),
        ],
      ),
      onTap: (date){
        //TODO check the tapped date with the bloc, let parent rebuild this widget
      },
      //TODO day builder

    );
  }
}
