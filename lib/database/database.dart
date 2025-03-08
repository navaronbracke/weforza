/// @docImport 'package:weforza/model/device/device.dart';
/// @docImport 'package:weforza/model/ride.dart';
/// @docImport 'package:weforza/model/rider/rider.dart';
/// @docImport 'package:weforza/model/settings/settings.dart';
library;

import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/database/import_riders_dao.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/rider_dao.dart';
import 'package:weforza/database/settings_dao.dart';

/// This interface defines the application database definition,
/// subdivided into a Database Access Object per separate table.
abstract interface class Database {
  /// Get the name of the database file.
  String get databaseName;

  /// Get the Database Access Object that manages the [Device]s.
  DeviceDao get deviceDao;

  /// Get the Database Access Object that manages the [Ride] exports.
  ExportRidesDao get exportRidesDao;

  /// Get the Database Access Object that manages the [Rider] imports.
  ImportRidersDao get importRidersDao;

  /// Get the Database Access Object that manages the [Ride]s.
  RideDao get rideDao;

  /// Get the Database Access Object that manages the [Rider]s.
  RiderDao get riderDao;

  /// Get the Database Access Object that manages the application [Settings].
  SettingsDao get settingsDao;

  /// Get the version of the database schema.
  int get version;

  /// Open the database.
  Future<void> open();

  /// Close the database.
  void dispose();
}
