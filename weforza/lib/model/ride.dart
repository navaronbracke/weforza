
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';

///This class represents a Ride.
class Ride {
  Ride(this.date,this.attendees) : assert(date != null && attendees != null);

  ///An id for in the database.
  int id;

  ///The Date of the Ride.
  final DateTime date;

  ///The attendees of the Ride.
  final List<Attendee> attendees;

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

  Map<String,dynamic> toMap(){
    return {
      "date": {
        "year": date.year,
        "month": date.month,
        "day": date.day,
      },
      "attendees": attendees.map((member) => {
        "firstname": member.firstname,
        "lastname": member.lastname,
        "phone": member.phone,
      })
    };
  }

  static Ride fromMap(Map<String,dynamic> map){
    Map<String,dynamic> dateMap = map["date"];
    DateTime date = DateTime(dateMap["year"],dateMap["month"],dateMap["day"]);
    List<dynamic> attendees = map["attendees"];
    return Ride(date,attendees.map((value) => Attendee(value["firstname"], value["lastname"], value["phone"])).toList());
  }
}

class Attendee {
  Attendee(this.firstname,this.lastname,this.phone): assert(firstname != null && lastname != null && phone != null);
  final String firstname;
  final String lastname;
  final String phone;
}