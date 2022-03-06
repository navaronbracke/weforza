import 'dart:io';

import 'package:file/file.dart' show FileSystem;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

import 'package:weforza/database/database_factory.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';

///This class wraps a Sembast [Database] and datastore instances along with initializer and close methods.
class ApplicationDatabase {
  ApplicationDatabase({this.databaseName = 'weforza_database.db'});

  //The database filename.
  final String databaseName;

  ///The data store for [Member].
  final memberStore = stringMapStoreFactory.store('member');

  ///The data store for [Ride].
  final rideStore = stringMapStoreFactory.store('ride');

  ///The data store for [RideAttendee].
  final rideAttendeeStore = stringMapStoreFactory.store('rideAttendee');

  ///The data store for the member devices.
  final deviceStore = stringMapStoreFactory.store('device');

  ///The data store for general application settings.
  final settingsStore = stringMapStoreFactory.store('settings');

  // The internal instance of the database.
  // We can assume that it is created before it is used.
  late Database _database;

  ///Get the database instance.
  Database getDatabase() => _database;

  //TODO remove when migrated to new directory.
  /// Moves the database from the old Documents directory
  /// to the Application Support directory for the current platform.
  Future<void> _moveDatabase(
      String newDatabasePath, FileSystem fileSystem) async {
    final oldDirectory = await getApplicationDocumentsDirectory();
    final oldDatabasePath = join(oldDirectory.path, databaseName);
    final file = fileSystem.file(oldDatabasePath);

    if (await file.exists()) {
      print('Found database on old location: $oldDatabasePath');
      print('Migrating database to new location: $newDatabasePath');

      try {
        print('Using migration strategy: RENAME FILE');

        await file.rename(newDatabasePath);
      } on FileSystemException {
        print('Migration using migration strategy: RENAME FILE failed.');
        print('Retrying with migration strategy: MOVE FILE');

        await file.copy(newDatabasePath);
        await file.delete();
      }

      print('Done migrating database.');
    }
  }

  ///Initialize the database.
  Future<void> openDatabase(ApplicationDatabaseFactory databaseFactory) async {
    final databaseDirectory = await getApplicationSupportDirectory();
    final dbPath = join(databaseDirectory.path, databaseName);

    // Move the database to the new directory if required.
    await _moveDatabase(dbPath, databaseFactory.fileSystem);

    _database = await databaseFactory.factory.openDatabase(dbPath);
  }

  void dispose() async => await _database.close();
}
