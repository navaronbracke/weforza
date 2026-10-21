import 'package:drift/drift.dart';

/// The table for the rides.
class Rides extends Table {
  /// The date on which this ride occurs in the calendar, in _**local time**_.
  ///
  /// Use [DateTime.toUtc] to convert the date back to UTC.
  DateTimeColumn get date => dateTime()();

  /// The unique identifier for the ride.
  ///
  /// This is an auto-increment id.
  IntColumn get id => integer().autoIncrement()();

  /// The amount of attendees that were automatically scanned for this ride.
  IntColumn get scannedAttendees => integer().nullable()();
}
