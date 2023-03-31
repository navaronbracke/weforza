import 'package:sembast/sembast.dart';

/// This class represents the different database table references.
class DatabaseTables {
  /// The device database table.
  static final device = stringMapStoreFactory.store('device');

  /// The ride database table.
  static final ride = stringMapStoreFactory.store('ride');

  /// The rider database table.
  static final rider = stringMapStoreFactory.store('member');

  /// The ride attendee database table.
  static final rideAttendee = stringMapStoreFactory.store('rideAttendee');

  /// The settings database table.
  static final settings = stringMapStoreFactory.store('settings');
}
