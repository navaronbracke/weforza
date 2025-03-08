/// @docImport 'package:weforza/database/database.dart';
/// @docImport 'package:weforza/model/rider/rider.dart';
library;

import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/rider/serializable_rider.dart';

/// This class represents the interface for working with [Rider]s from the [Database],
/// for the purpose of importing.
abstract interface class ImportRidersDao {
  /// Save the given [riders].
  Future<void> saveSerializableRiders(Iterable<SerializableRider> riders, {required FileUriParser fileUriParser});
}
