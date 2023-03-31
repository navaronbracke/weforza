
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weforza/file/exportable.dart';

///This class represents a Ride.
class Ride implements Exportable {
  Ride({
    @required this.date,
    this.title,
    this.startAddress,
    this.destinationAddress,
    this.distance = 0.0
  }): assert(date != null && distance != null);

  ///Date formatting patterns
  static final String longDatePattern = "EEEE d MMMM yyyy";
  static final String shortDatePattern = "EEE d MMM yyyy";

  static final int titleMaxLength = 80;

  ///Address regex for departure/destination addresses.
  ///Between 1 and 80 letters, digits, spaces or characters that are included in the regex.
  ///The first group in the regex OR are the regex pattern classes for digits, whitespace and letters.
  ///The second group are the characters that don't have to be escaped,
  ///while the last group contains the characters that have to be escaped for the pattern.
  static final RegExp addressRegex = RegExp(r"^([\p{Letter}\d\s]|[#,;:'&/°]|[\.\(\)\-]){1,80}$",unicode: true);

  ///Convert a number's mantissa.
  ///This method converts commas into dots and dots into commas.
  ///If the value is null or doesn't contain a number nor a mantissa, the value is returned unmodified.
  ///Else the value is returned with its mantissa replaced by its opposite, a comma if it was a dot and a dot if it was a comma.
  ///Only the dot and comma can be used as separators.
  ///[oldSeparator] and [newSeparator] should be each other's opposite. Thus either "," and "." or "." and "," .
  static String convertNumberSeparator(String value, {String oldSeparator = ",", String newSeparator = "."}){
    assert((oldSeparator == "," && newSeparator == ".") || (oldSeparator == "." && newSeparator == ","));

    final distanceRegex = (oldSeparator == ",") ? RegExp(r"^\d+,\d+$") : RegExp(r"^\d+\.\d+$");
    if(value != null && distanceRegex.hasMatch(value)){
      //Fix delimiter
      final values = value.split(oldSeparator);
      value = "${values[0]}$newSeparator${values[1]}";
    }
    return value;
  }

  ///The Date of the Ride. This is the key for the stored record.
  final DateTime date;

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
      title: values["title"],
      destinationAddress: values["destination"],
      startAddress: values["start"],
      distance: values["distance"]
    );
  }

  @override
  bool operator ==(Object other) => other is Ride && date == other.date
      && title == other.title && startAddress == other.startAddress
      && destinationAddress == other.destinationAddress
      && distance == other.distance;

  @override
  int get hashCode => hashValues(date,title,startAddress,destinationAddress,distance);

  String dateToDDMMYYY() => "${date.day}-${date.month}-${date.year}";

  @override
  Map<String, String> exportToJson() {
    return {
      "date": dateToDDMMYYY(),
      "title": title,
      "destination": destinationAddress,
      "start": startAddress,
      "distance": distance == null || distance == 0.0 ? "0 Km" : "$distance Km"
    };
  }

  @override
  String exportToCsv() {
    String value = dateToDDMMYYY();
    value = "$value,${title ?? ""},";
    value = "$value${startAddress ?? ""},";
    value = "$value${destinationAddress ?? ""},";

    if(distance == null || distance == 0.0){
      value = value + "0 Km";
    }else{
      value = value + "$distance Km";
    }

    return value;
  }
}