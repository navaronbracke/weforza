
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:weforza/model/RideAttendee.dart';

///This class represents a Ride.
class Ride {
  Ride(this.date) : assert(date != null);

  ///The Date of the Ride. This is the key for the stored record.
  final DateTime date;

  ///A date formatting pattern for in the top of the detail page.
  final String datePattern = "EEEE d MMMM yyyy";

  ///The number of attendees.
  ///This is separately calculated from the entries in [RideAttendee].
  int numberOfAttendees = 0;

  ///Get [date], but formatted with a day prefix.
  String getFormattedDate(BuildContext context){
    return DateFormat(datePattern,Localizations.localeOf(context)
        .languageCode).format(date);
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