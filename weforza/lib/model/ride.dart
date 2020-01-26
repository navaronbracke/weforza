
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

///This class represents a Ride.
class Ride {
  Ride(this.date,[this.numberOfAttendees = 0]) : assert(date != null && numberOfAttendees != null);

  ///The Date of the Ride. This is the key for the stored record.
  final DateTime date;

  ///A date formatting pattern for in the top of the detail page.
  final String datePattern = "EEEE d MMMM yyyy";

  ///The number of attendees.
  int numberOfAttendees;

  ///Get [date], but formatted with a day prefix.
  String getFormattedDate(BuildContext context){
    return DateFormat(datePattern,Localizations.localeOf(context)
        .languageCode).format(date);
  }

  ///Convert this object to a Map.
  Map<String,dynamic> toMap() => {
    "attendees": numberOfAttendees
  };

  ///Create a [Ride] of a Map
  static Ride of(DateTime date,Map<String,dynamic> values){
    assert(date != null && values != null);
    return Ride(date,values["attendees"]);
  }

  @override
  bool operator ==(Object other) => other is Ride && date == other.date && numberOfAttendees == other.numberOfAttendees;

  @override
  int get hashCode => hashValues(date,numberOfAttendees);
}