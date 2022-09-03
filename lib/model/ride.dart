import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show DateFormat;

/// This class represents a ride in the ride calendar.
/// Each ride has a [date] and the number of [scannedAttendees].
class Ride {
  /// The default constructor.
  const Ride({required this.date, this.scannedAttendees});

  /// Create a ride from the given [date] and [values].
  factory Ride.of(DateTime date, Map<String, dynamic> values) {
    return Ride(
      date: date,
      scannedAttendees: values['scannedAttendees'] as int?,
    );
  }

  /// The date on which this ride occurs in the calendar.
  final DateTime date;

  /// The amount of attendees that were automatically scanned for this ride.
  ///
  /// This variable is purely used for statistics and is not exported.
  final int? scannedAttendees;

  /// The long date formating pattern for [date].
  static const longDatePattern = 'EEEE d MMMM yyyy';

  /// The short date formating pattern for [date].
  static const shortDatePattern = 'EEE d MMM yyyy';

  /// Get the [date] as a `DD-MM-YYYY` formatted string.
  String get dateAsDayMonthYear => '${date.day}-${date.month}-${date.year}';

  /// Format the [date] to a given pattern.
  ///
  /// If [shortForm] is true, the date is formatted using [shortDatePattern].
  /// Otherwise it is formatted using [longDatePattern].
  String getFormattedDate(BuildContext context, [bool shortForm = true]) {
    return DateFormat(
      shortForm ? shortDatePattern : longDatePattern,
      Localizations.localeOf(context).languageCode,
    ).format(date);
  }

  /// Convert this ride into an exportable comma separated value string.
  String toCsv() => dateAsDayMonthYear;

  /// Convert this ride into an exportable JSON object.
  Map<String, String> toJson() => {'date': dateAsDayMonthYear};

  /// Convert this ride into a map.
  /// The date is excluded, as that is the key of the record.
  Map<String, dynamic> toMap() => {'scannedAttendees': scannedAttendees};

  @override
  bool operator ==(Object other) {
    return other is Ride &&
        date == other.date &&
        scannedAttendees == other.scannedAttendees;
  }

  @override
  int get hashCode => Object.hash(date, scannedAttendees);
}
