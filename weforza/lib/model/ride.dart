
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/attendee.dart';

///This class represents a Ride.
class Ride {
  Ride(this.date,this.attendees) : assert(date != null && attendees != null);

  ///An id for in the database.
  int id;

  ///The Date of the Ride.
  final DateTime date;

  ///The attendees of the Ride.
  final List<Attendee> attendees;

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
      "date": date.toString(),
      "attendees": attendees.map((member) => member.toMap())
    };
  }

  ///Create a Ride from a Map.
  static Ride fromMap(Map<String,dynamic> map){
    List<dynamic> attendees = map["attendees"];
    return Ride(DateTime.parse(map["date"]),attendees.map((value) => Attendee.fromMap(value)).toList());
  }

  @override
  bool operator ==(Object other) => other is Ride && date == other.date;

  @override
  int get hashCode => hashValues(date,hashList(attendees));
}