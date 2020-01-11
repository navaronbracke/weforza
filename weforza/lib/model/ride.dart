
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/RideAttendee.dart';

///This class represents a Ride.
class Ride {
  Ride(this.date) : assert(date != null);

  ///The Date of the Ride. This is the key for the stored record.
  final DateTime date;
  ///The number of attendees.
  ///This is separately calculated from the entries in [RideAttendee].
  int numberOfAttendees = 0;

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
  ///We do not really store any data (yet).
  ///The date is the key, so we do not include it here.
  Map<String,dynamic> toMap() => {};

  @override
  bool operator ==(Object other) => other is Ride && date == other.date && numberOfAttendees == other.numberOfAttendees;

  @override
  int get hashCode => hashValues(date,numberOfAttendees);
}