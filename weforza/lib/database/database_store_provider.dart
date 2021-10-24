import 'package:sembast/sembast.dart';

/// This class provides the database tables.
class DatabaseStoreProvider {
  ///The data store for [Member].
  final memberStore = stringMapStoreFactory.store("member");

  ///The data store for [Ride].
  final rideStore = stringMapStoreFactory.store("ride");

  ///The data store for [RideAttendee].
  final rideAttendeeStore = stringMapStoreFactory.store("rideAttendee");

  ///The data store for the member devices.
  final deviceStore = stringMapStoreFactory.store("device");

  ///The data store for general application settings.
  final settingsStore = stringMapStoreFactory.store("settings");
}