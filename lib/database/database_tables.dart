import 'package:sembast/sembast.dart';

/// This class represents the different database table references.
class DatabaseTables {
  /// The device database table.
  static final device = stringMapStoreFactory.store('device');

  /// The member database table.
  static final member = stringMapStoreFactory.store('member');

  /// The ride database table.
  static final ride = stringMapStoreFactory.store('ride');

  /// The ride attendee database table.
  static final rideAttendee = stringMapStoreFactory.store('rideAttendee');

  /// The settings database table.
  static final settings = stringMapStoreFactory.store('settings');
}
