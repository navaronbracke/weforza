import 'dart:async';
import 'dart:io';

import 'package:file/memory.dart';
import 'package:file_testing/file_testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

import 'package:weforza/database/database.dart';
import 'package:weforza/database/databaseFactory.dart';

/// This fake database provides an implementation for testing database creation.
/// It does not support actual transactions.
/// For testing transactions, an actual in-memory database can be used.
class FakeDatabase implements Database {
  FakeDatabase({
    required this.path,
    required this.version,
  });

  @override
  int version;

  @override
  final String path;

  @override
  Future close() => Future.value();

  @override
  Future<T> transaction<T>(
    FutureOr<T> Function(Transaction transaction) action,
  ) {
    throw UnsupportedError(
      'FakeDatabase does not support transactions. '
      'Use an in-memory database instead of a fake one.',
    );
  }
}

/// This fake database factory provides an implementation
/// for testing database creation.
/// It does not support incrementing database versions,
/// codecs and database opening modes.
class FakeDatabaseFactory implements DatabaseFactory {
  final MemoryFileSystem fileSystem = MemoryFileSystem();

  /// Uses an in memory database.
  @override
  bool get hasStorage => false;

  @override
  Future<void> deleteDatabase(String path) async {
    final File database = fileSystem.file(path);

    if (await database.exists()) {
      await database.delete();
    }
  }

  @override
  Future<Database> openDatabase(
    String path, {
    int? version,
    OnVersionChangedFunction? onVersionChanged,
    DatabaseMode? mode,
    SembastCodec? codec,
  }) async {
    final File storage = fileSystem.file(path);

    if (await storage.exists()) {
      return FakeDatabase(path: storage.path, version: version ?? 1);
    }

    // Use recursive to avoid having to create empty directories separately.
    // It's just for testing anyway.
    final File newStorage = await storage.create(recursive: true);
    return FakeDatabase(path: newStorage.path, version: version ?? 1);
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /*
  Run this test:
  flutter drive --driver=test_driver/integration_test.dart --target=integration_test/database_location_test.dart
  */
  group('Database creation tests', () {
    /// Integration / regression test for new database creation.
    /// New databases should be created in
    /// the Application Support directory provided by the platform.
    ///
    /// New databases should also be created with the correct version number.
    testWidgets(
      'New databases are created in the Application Support Directory',
      (WidgetTester tester) async {
        const testDbName = 'test_database.db';
        final applicationDatabase =
            ApplicationDatabase(databaseName: testDbName);

        // Setup the fake file system.
        // Only provide the application support folder.
        final newDirectory = await getApplicationSupportDirectory();
        final dbFactory = ApplicationDatabaseFactory(
          fileSystem: MemoryFileSystem(),
          factory: FakeDatabaseFactory(),
        );

        // Create the actual database.
        await applicationDatabase.openDatabase(dbFactory);

        final newDatabasePath = path.join(newDirectory.path, testDbName);
        final realDb = applicationDatabase.getDatabase();

        // There is currently no database migration in use.
        // Thus new databases should start with version 1.
        expect(realDb.path, newDatabasePath);
        expect(realDb.version, 1);
      },
    );

    /// Integration / regression test for old databases that need to be moved
    /// to the Application Support directory provided by the platform.
    ///
    /// Older versions of the application used to store their database
    /// in the Documents directory.
    /// Newer version correctly store the database
    /// in the Application Support directory.
    testWidgets(
      'Database in documents directory is moved to application support directory',
      (WidgetTester tester) async {
        const testDbName = 'test_database.db';
        final db = ApplicationDatabase(databaseName: testDbName);
        final dbFactory = ApplicationDatabaseFactory(
          fileSystem: MemoryFileSystem(),
          factory: FakeDatabaseFactory(),
        );

        // Setup the fake file system.
        // Provide the old and new folders where the database files exist.
        final oldDirectory = await getApplicationDocumentsDirectory();
        final newDirectory = await getApplicationSupportDirectory();

        // Create a database in the old directory.
        final oldDatabasePath = path.join(oldDirectory.path, testDbName);
        await dbFactory.factory.openDatabase(oldDatabasePath);

        // Try to open the application database.
        // Since the 'old' database is in the wrong directory,
        // we expect it to be moved.
        await db.openDatabase(dbFactory);

        final newDatabasePath = path.join(newDirectory.path, testDbName);
        final newDatabase = db.getDatabase();

        // There is currently no database migration in use.
        // Thus databases should start with version 1.
        expect(newDatabase.version, 1);
        expect(newDatabase.path, newDatabasePath);
        expect(dbFactory.fileSystem.file(oldDatabasePath), isNot(exists));
      },
    );
  });
}
