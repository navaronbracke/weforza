/// @docImport 'package:weforza/model/export/exportable_ride_attendee.dart';
library;

import 'package:weforza/database/database.dart';
import 'package:weforza/utils/date_format_utils.dart';

/// An exportable [Ride], without its [RideAttendee]s metadata.
///
/// The [RideAttendee] are exported separately using [ExportableRideAttendee].
class ExportableRide {
  new({required this.date});

  /// The date of the ride.
  final DateTime date;

  /// Convert this ride into an exportable comma separated value string.
  String toCsv() => date.asDayMonthYear;

  /// Convert this ride into an exportable JSON object.
  Map<String, String> toJson() => {'date': date.asDayMonthYear};
}
