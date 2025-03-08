/// @docImport 'package:weforza/database/database.dart';
library;

import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/export/exportable_ride.dart';

/// This class represents the interface for working with rides from the [Database],
/// for the purpose of exporting.
abstract class ExportRidesDao {
  /// Get the exportable rides with their attendees.
  ///
  /// If a specific [ride] date is given, only that ride is returned.
  Future<Iterable<ExportableRide>> getRides(DateTime? ride, {required FileUriParser fileUriParser});
}
