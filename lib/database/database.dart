import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/database/import_riders_dao.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/rider_dao.dart';
import 'package:weforza/database/settings_dao.dart';

/// This interface defines the application database definition.
abstract interface class Database {
  /// Get the name of the database file.
  String get databaseName;

  /// Get the database access object that manages the devices.
  DeviceDao get deviceDao;

  /// Get the database access object that manages the ride exports.
  ExportRidesDao get exportRidesDao;

  /// Get the database access object that manages the rider imports.
  ImportRidersDao get importRidersDao;

  /// Get the database access object that manages the rides.
  RideDao get rideDao;

  /// Get the database access object that manages the riders.
  RiderDao get riderDao;

  /// Get the database access object that manages the application settings.
  SettingsDao get settingsDao;

  /// Get the version of the database schema.
  int get version;

  /// Open the database.
  Future<void> open();

  /// Close the database.
  void dispose();
}
