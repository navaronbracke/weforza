import 'package:drift/drift.dart';
import 'package:weforza/database/riders.dart';
import 'package:weforza/database/rides.dart';

part 'database.g.dart';

/// The table for the ride attendees.
class RideAttendees extends Table {
  /// The unique identifier for the ride attendee.
  ///
  /// This is an auto-increment id.
  IntColumn get id => integer().autoIncrement()();

  /// Whether the attendee was scanned.
  ///
  /// If this is false, the attendee was manually selected.
  ///
  /// Defaults to true.
  BoolColumn get isScanned => boolean().withDefault(const Constant(true))();

  /// The [Rides.id] of the ride that was attended.
  ///
  /// If the ride is deleted, this attendee record is deleted as well.
  IntColumn get rideId => integer().references(Rides, #id, onDelete: .cascade)();

  /// The [Riders.id] of the rider that attended the ride.
  ///
  /// If the rider is deleted, this attendee record is deleted as well.
  IntColumn get riderId => integer().references(Riders, #id, onDelete: .cascade)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {rideId, riderId},
  ];
}
