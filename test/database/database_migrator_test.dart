import 'package:drift/drift.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/database_migrator.dart';

void main() {
  late WeForzaDatabase database;
  late MemoryFileSystem fileSystem;
  late Directory oldDatabaseDirectory;
  late File oldDatabaseFile;

  DatabaseMigrator createMigrator(WeForzaDatabase database, MemoryFileSystem fileSystem) {
    return .test(database, fileSystem: fileSystem, getDatabaseDirectory: (fileSystem) async => oldDatabaseDirectory);
  }

  Future<void> expectDatabaseIsEmpty(WeForzaDatabase database) async {
    expect(await database.devices.count().getSingle(), 0);
    expect(await database.excludedTerms.count().getSingle(), 0);
    expect(await database.rideAttendees.count().getSingle(), 0);
    expect(await database.riders.count().getSingle(), 0);
    expect(await database.rides.count().getSingle(), 0);
  }

  Future<void> writeLinesToOldDatabaseFile(Iterable<String> lines) async {
    await oldDatabaseFile.create(recursive: true);
    await oldDatabaseFile.writeAsString(lines.join('\n'));
  }

  setUp(() {
    database = .memory();
    fileSystem = MemoryFileSystem();
    oldDatabaseDirectory = fileSystem.systemTempDirectory.childDirectory('old');
    oldDatabaseFile = oldDatabaseDirectory.childFile(DatabaseMigrator.oldDatabaseName);
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.withData(<String, Object>{});
  });

  tearDown(() async {
    await database.close();
  });

  group('invalid old database', () {
    test('does not write to database if old database file does not exist', () async {
      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database file contains no bytes', () async {
      await writeLinesToOldDatabaseFile([]);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database file is not a json text file', () async {
      await oldDatabaseFile.create(recursive: true);
      await oldDatabaseFile.writeAsBytes([0, 1, 2]);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database file content is the empty string', () async {
      await writeLinesToOldDatabaseFile(['']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database file content is random string', () async {
      await writeLinesToOldDatabaseFile(['foo', 'bar']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database file content is empty json object', () async {
      await writeLinesToOldDatabaseFile(['{}']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database file content is invalid json object format', () async {
      await writeLinesToOldDatabaseFile(['{"foo": 1}']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database file content is json array', () async {
      await writeLinesToOldDatabaseFile(['[]']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database version is a string', () async {
      await writeLinesToOldDatabaseFile(['{"version":"foo"}']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database version is negative', () async {
      await writeLinesToOldDatabaseFile(['{"version":-1}']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database version is not an integer', () async {
      await writeLinesToOldDatabaseFile(['{"version":1.5}']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database version is missing database name marker', () async {
      await writeLinesToOldDatabaseFile(['{"version":1}']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database version is not on the first line', () async {
      await writeLinesToOldDatabaseFile(['{"foo": "bar"}', '{"version":1}']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('does not write to database if old database is empty', () async {
      await writeLinesToOldDatabaseFile(['{"version":1,"sembast":1}']);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });
  });
}
