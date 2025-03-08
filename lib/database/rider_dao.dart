import 'package:sembast/sembast.dart';
import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';

/// This class represents the interface for working with [Rider]s from the [Database].
abstract interface class RiderDao {
  /// Add a [rider].
  Future<void> addRider(Rider rider);

  /// Delete the rider with the given [uuid].
  Future<void> deleteRider(String uuid);

  /// Get the amount of rides that a rider with the given [uuid] has attended.
  Future<int> getAttendingCount(String uuid);

  /// Get the list of riders that satisfy the given [filter].
  Future<List<Rider>> getRiders(RiderFilterOption filter, {required FileUriParser fileUriParser});

  /// Toggle the active state of the rider with the given [uuid].
  Future<void> setRiderActive(String uuid, {required bool value});

  /// Update the given [rider].
  Future<void> updateRider(Rider rider);
}
