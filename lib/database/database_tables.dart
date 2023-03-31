import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

/// This provider provides the database tables.
final databaseTableProvider = Provider((_) => DatabaseTables());

/// This class represents the different database table references.
class DatabaseTables {
  /// The device database table.
  final device = stringMapStoreFactory.store('device');

  /// The member database table.
  final member = stringMapStoreFactory.store('member');

  /// The ride database table.
  final ride = stringMapStoreFactory.store('ride');

  /// The ride attendee database table.
  final rideAttendee = stringMapStoreFactory.store('rideAttendee');

  /// The settings database table.
  final settings = stringMapStoreFactory.store('settings');
}
