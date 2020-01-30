
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

///This class represents a Ride.
class Ride {
  Ride({
    @required this.date,
    this.numberOfAttendees = 0,
    this.title,
    this.startAddress,
    this.destinationAddress,
    this.distance = 0.0
  }): assert(date != null && numberOfAttendees != null && distance != null);

  ///Date formatting patterns
  static final String longDatePattern = "EEEE d MMMM yyyy";
  static final String shortDatePattern = "EEE d MMM yyyy";

  ///Address regex for departure/destination addresses.
  ///Between 1 and 80 letters, digits, spaces or characters that are included in the regex.
  ///The first group in the regex OR are the regex pattern classes for digits, whitespace and letters.
  ///The second group are the characters that don't have to be escaped,
  ///while the last group contains the characters that have to be escaped for the pattern.
  static final RegExp addressRegex = RegExp(r"^([\p{Letter}\d\s]|[#,;:'&/°]|[\.\(\)\-]){1,80}$",unicode: true);

  ///The Date of the Ride. This is the key for the stored record.
  final DateTime date;

  ///The number of attendees.
  int numberOfAttendees;

  ///The ride's title.
  String title;

  ///The ride's starting address.
  String startAddress;

  ///The ride's destination address.
  String destinationAddress;

  ///The ride's total distance.
  double distance;

  ///Get [date], but formatted with a day prefix.
  ///This method can return a short or long format, depending on [shortForm].
  String getFormattedDate(BuildContext context,[bool shortForm = true]){
    return DateFormat(shortForm ? shortDatePattern : longDatePattern,Localizations.localeOf(context)
        .languageCode).format(date);
  }

  ///Convert this object to a Map.
  ///The date is excluded since this is the record's key.
  Map<String,dynamic> toMap() => {
    "attendees": numberOfAttendees,
    "title": title,
    "start": startAddress,
    "destination": destinationAddress,
    "distance": distance,
  };

  ///Create a [Ride] of a Map
  static Ride of(DateTime date,Map<String,dynamic> values){
    assert(date != null && values != null);
    return Ride(
      date: date,
      numberOfAttendees: values["attendees"],
      title: values["title"],
      destinationAddress: values["destination"],
      startAddress: values["start"],
      distance: values["distance"]
    );
  }

  @override
  bool operator ==(Object other) => other is Ride && date == other.date
      && numberOfAttendees == other.numberOfAttendees && title == other.title
      && startAddress == other.startAddress && destinationAddress == other.destinationAddress
      && distance == other.distance;

  @override
  int get hashCode => hashValues(date,numberOfAttendees,title,startAddress,destinationAddress,distance);
}