/// @docImport 'package:weforza/model/export/exportable_ride_attendee.dart';
library;

import 'package:weforza/database/database.dart';
import 'package:weforza/utils/date_format_utils.dart';

/// An exportable [Ride], without its [RideAttendee]s metadata.
///
/// The [RideAttendee] are exported separately using [ExportableRideAttendee].
final class ExportableRide {
  const new({required this.date});

  /// The date of the ride.
  final DateTime date;

  /// Convert this ride into an exportable comma separated value string.
  String toCsv() => date.asDayMonthYear;

  /// Convert this ride into an exportable JSON object.
  Map<String, String> toJson() => {'date': date.asDayMonthYear};

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ExportableRide && date == other.date;
  }

  @override
  int get hashCode => date.hashCode;
}
