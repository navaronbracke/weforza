/// @docImport 'package:weforza/database/database.dart';
/// @docImport 'package:weforza/model/ride.dart';
library;

import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/export/exportable_ride.dart';

/// This class represents the interface for working with [Ride]s from the [Database],
/// for the purpose of exporting.
abstract interface class ExportRidesDao {
  /// Get the exportable rides with their attendees.
  ///
  /// If a specific [ride] date is given, only that ride is returned.
  Future<Iterable<ExportableRide>> getRides(DateTime? ride, {required FileUriParser fileUriParser});
}
