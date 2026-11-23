import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/database_migrator.dart';

import 'database_migrator_test_utils.dart';

void main() {
  late WeForzaDatabase database;
  late MemoryFileSystem fileSystem;
  late Directory oldDatabaseDirectory;
  late File oldDatabaseFile;

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

  group('does not write to database if old database file', () {
    test('does not exist', () async {
      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('contains no bytes', () async {
      await writeLinesToOldDatabaseFile([], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('is not a json text file', () async {
      await oldDatabaseFile.create(recursive: true);
      await oldDatabaseFile.writeAsBytes([0, 1, 2]);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('bytes content is the empty string', () async {
      await writeLinesToOldDatabaseFile([''], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('bytes content is random string', () async {
      await writeLinesToOldDatabaseFile(['foo', 'bar'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('bytes content is empty json object', () async {
      await writeLinesToOldDatabaseFile(['{}'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('bytes content is invalid json object format', () async {
      await writeLinesToOldDatabaseFile(['{"foo": 1}'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('bytes content is json array', () async {
      await writeLinesToOldDatabaseFile(['[]'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('version marker value is a string', () async {
      await writeLinesToOldDatabaseFile(['{"version":"foo"}'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('version marker value is negative', () async {
      await writeLinesToOldDatabaseFile(['{"version":-1}'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('version marker value is not an integer number', () async {
      await writeLinesToOldDatabaseFile(['{"version":1.5}'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('version marker value is missing database name marker', () async {
      await writeLinesToOldDatabaseFile(['{"version":1}'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('version marker value is not on the first line', () async {
      await writeLinesToOldDatabaseFile(['{"foo": "bar"}', '{"version":1}'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('database records value is empty', () async {
      await writeLinesToOldDatabaseFile(['{"version":1,"sembast":1}'], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });
  });

  group('record lines validation', () {
    test('migrator ignores invalid store names in records', () async {
      await writeLinesToOldDatabaseFile([
        '{"version":1,"sembast":1}',
        '{"key":"2026-10-17T00:00:00.000","store":"ridesFoo","value":{"scannedAttendees":null}}',
      ], oldDatabaseFile);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });
  });
}
