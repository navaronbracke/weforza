import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

import 'package:weforza/database/database.dart';
import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/database/import_riders_dao.dart';
import 'package:weforza/database/ride_dao.dart';
import 'package:weforza/database/rider_dao.dart';
import 'package:weforza/database/settings_dao.dart';

/// This class represents a [Database] implementation that uses a Sembast database under the hood.
class SembastDatabase implements Database {
  /// Create an on-disk database.
  SembastDatabase() : _factory = databaseFactoryIo, databaseName = 'weforza_database.db';

  /// Create an in-memory database.
  SembastDatabase.memory() : _factory = databaseFactoryMemory, databaseName = 'test_database.db';

  /// The internal instance of the database.
  late sembast.Database _database;

  /// The database factory that will open the [_database].
  final sembast.DatabaseFactory _factory;

  @override
  final String databaseName;

  @override
  DeviceDao get deviceDao => DeviceDaoImpl(_database);

  @override
  ExportRidesDao get exportRidesDao => ExportRidesDaoImpl(_database);

  @override
  ImportRidersDao get importRidersDao => ImportRidersDaoImpl(_database);

  @override
  RideDao get rideDao => RideDaoImpl(_database);

  @override
  RiderDao get riderDao => RiderDaoImpl(_database);

  @override
  SettingsDao get settingsDao => SettingsDaoImpl(_database);

  @override
  int get version => 1; // No schema migrations are currently in use.

  @override
  Future<void> open() async {
    final databaseDirectory = await getApplicationSupportDirectory();

    final databasePath = join(databaseDirectory.path, databaseName);

    _database = await _factory.openDatabase(
      databasePath,
      version: version,
      onVersionChanged: (sembast.Database db, int oldVersion, int newVersion) async {
        // No schema migrations are currently in use.
      },
    );
  }

  @override
  void dispose() async => await _database.close();
}
