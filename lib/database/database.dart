// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file/file.dart' show FileSystem;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

import 'package:weforza/database/database_factory.dart';

/// This class represents the application database.
class ApplicationDatabase {
  ApplicationDatabase({this.databaseName = 'weforza_database.db'});

  /// The name of the database file.
  final String databaseName;

  /// The internal instance of the database.
  late Database _database;

  /// Get the database instance.
  Database getDatabase() => _database;

  // TODO remove this method when migrated to new directory.
  // Also remove the ignore_for_file above.

  /// Moves the database from the old Documents directory
  /// to the Application Support directory for the current platform.
  Future<void> _moveDatabase(
    String newDatabasePath,
    FileSystem fileSystem,
  ) async {
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

  /// Open the database using the provided [databaseFactory].
  Future<void> openDatabase(ApplicationDatabaseFactory databaseFactory) async {
    final databaseDirectory = await getApplicationSupportDirectory();
    final dbPath = join(databaseDirectory.path, databaseName);

    // Move the database to the new directory if required.
    await _moveDatabase(dbPath, databaseFactory.fileSystem);

    _database = await databaseFactory.factory.openDatabase(dbPath);
  }

  /// Close the database.
  void dispose() async => await _database.close();
}
