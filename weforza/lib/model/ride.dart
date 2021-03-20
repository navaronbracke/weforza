
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

///This class represents a Ride.
class Ride {
  Ride({
    required this.date
  });

  ///Date formatting patterns
  static final String longDatePattern = "EEEE d MMMM yyyy";
  static final String shortDatePattern = "EEE d MMM yyyy";

  ///The Date of the Ride. This is the key for the stored record.
  final DateTime date;

  ///Get [date], but formatted with a day prefix.
  ///This method can return a short or long format, depending on [shortForm].
  String getFormattedDate(BuildContext context,[bool shortForm = true]){
    return DateFormat(shortForm ? shortDatePattern : longDatePattern,Localizations.localeOf(context)
        .languageCode).format(date);
  }

  ///Convert this object to a Map.
  ///The date is excluded since this is the record's key.
  Map<String,dynamic> toMap() => {};

  ///Create a [Ride] of a Map
  static Ride of(DateTime date,Map<String,dynamic> values){
    return Ride(date: date);
  }

  @override
  bool operator ==(Object other) => other is Ride && date == other.date;

  @override
  int get hashCode => date.hashCode;

  String dateToDDMMYYY() => "${date.day}-${date.month}-${date.year}";
  
  Map<String, String> toJson() => {
      "date": dateToDDMMYYY(),
    };

  String toCsv() => dateToDDMMYYY();
}