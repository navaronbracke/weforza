/// @docImport 'package:weforza/model/export/exportable_ride_attendee.dart';
library;

import 'package:weforza/database/database.dart';

/// An exportable [Ride], without its [RideAttendee]s metadata.
///
/// The [RideAttendee] are exported separately using [ExportableRideAttendee].
class ExportableRide {
  ExportableRide({required this.date});

  /// The date of the ride.
  final DateTime date;

  String get _dateAsDayMonthYear => '${date.day}-${date.month}-${date.year}';

  /// Convert this ride into an exportable comma separated value string.
  String toCsv() => _dateAsDayMonthYear;

  /// Convert this ride into an exportable JSON object.
  Map<String, String> toJson() => {'date': _dateAsDayMonthYear};
}
