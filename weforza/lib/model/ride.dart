
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';

///This class represents a Ride.
class Ride {
  Ride(this.date,[this.numberOfAttendees = 0]) : assert(date != null && numberOfAttendees != null);

  ///The Date of the Ride. This is the key for the stored record.
  final DateTime date;
  ///The number of attendees.
  int numberOfAttendees;

  ///Get [date], but formatted with a day prefix.
  String getFormattedDate(BuildContext context){
    String prefix;
    switch(date.weekday){
      case 1: prefix = "${S.of(context).MondayPrefix}";
      break;
      case 2: prefix = "${S.of(context).TuesdayPrefix}";
      break;
      case 3: prefix = "${S.of(context).WednesdayPrefix}";
      break;
      case 4: prefix = "${S.of(context).ThursdayPrefix}";
      break;
      case 5: prefix = "${S.of(context).FridayPrefix}";
      break;
      case 6: prefix = "${S.of(context).SaturdayPrefix}";
      break;
      case 7: prefix = "${S.of(context).SundayPrefix}";
    }
    return prefix == null ? S.of(context).UnknownDate : "$prefix ${date.day}-${date.month}-${date.year}";
  }

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "numberOfAttendees": numberOfAttendees
    };
  }

  static Ride of(DateTime date, Map<String,dynamic> values){
    assert(date != null && values != null);
    return Ride(date,values["numberOfAttendees"]);
  }

  @override
  bool operator ==(Object other) => other is Ride && date == other.date && numberOfAttendees == other.numberOfAttendees;

  @override
  int get hashCode => hashValues(date,numberOfAttendees);
}