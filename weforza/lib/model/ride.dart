
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

///This class represents a Ride.
class Ride {
  Ride({
    required this.date,
    this.scannedAttendees,
  });

  ///Date formatting patterns
  static final String longDatePattern = "EEEE d MMMM yyyy";
  static final String shortDatePattern = "EEE d MMM yyyy";

  /// The Date of the Ride. This is the key for the stored record.
  final DateTime date;

  /// The amount of attendees that were automatically scanned for this ride.
  /// This is a statistical piece of information, that is not exported.
  /// Only attendees that were automatically scanned
  /// by the algorithm are considered.
  ///
  /// For compatibility reasons, this variable is nullable.
  /// I.e. A new or existing ride without this attribute does not have a value.
  int? scannedAttendees;

  ///Get [date], but formatted with a day prefix.
  ///This method can return a short or long format, depending on [shortForm].
  String getFormattedDate(BuildContext context,[bool shortForm = true]){
    return DateFormat(
        shortForm ? shortDatePattern : longDatePattern,
        Localizations.localeOf(context).languageCode,
    ).format(date);
  }

  ///Convert this object to a Map.
  ///The date is excluded since this is the record's key.
  Map<String,dynamic> toMap() => {
    "scannedAttendees": scannedAttendees
  };

  ///Create a [Ride] of a Map
  static Ride of(DateTime date,Map<String,dynamic> values){
    return Ride(date: date, scannedAttendees: values["scannedAttendees"]);
  }

  @override
  bool operator ==(Object other) => other is Ride
      && date == other.date
      && scannedAttendees == other.scannedAttendees;

  @override
  int get hashCode => hashValues(date, scannedAttendees);

  String dateToDDMMYYYY() => "${date.day}-${date.month}-${date.year}";

  // Exporting formats.
  // Note: scannedAttendees is never exported.
  Map<String, String> toJson() => {"date": dateToDDMMYYYY()};
  String toCsv() => dateToDDMMYYYY();
}