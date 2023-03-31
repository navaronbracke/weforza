import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weforza/theme/appTheme.dart';

///The calendar header displays a label in the center.
///This label is the current month + year.
class AddRideCalenderHeader extends StatelessWidget {
  AddRideCalenderHeader({ @required this.stream }): assert(stream != null);

  final Stream<DateTime> stream;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: StreamBuilder<DateTime>(
        stream: stream,
        builder: (context, snapshot){
          if(snapshot.data == null){
            return Container(height: 50);
          }else{
            return Center(
              child: Text(DateFormat.MMMM(Localizations.localeOf(context)
                  .languageCode)
                  .add_y()
                  .format(snapshot.data),
                style: TextStyle(color: ApplicationTheme.rideCalendarHeaderColor),
              ),
            );
          }
        },
      ),
    );
  }
}
