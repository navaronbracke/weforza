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

  group('record validation', () {
    test('migrator ignores invalid store names in records', () async {
      await writeLinesToOldDatabaseFile([
        '{"version":1,"sembast":1}',
        '{"key":"2026-10-17T00:00:00.000","store":"foo","value":{"scannedAttendees":null}}',
      ]);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('migrator ignores records without a key', () async {
      await writeLinesToOldDatabaseFile([
        '{"version":1,"sembast":1}',
        '{"store":"ride","value":{"scannedAttendees":null}}',
        '{"store":"member","value":{"active":true,"alias":"J","firstname":"R","lastname":"B","lastUpdated":"2026-10-18 10:02:02.78","profile":null}}',
        '{"store":"device","value":{"deviceName":"device1","owner":"59954196-d883-4477-b612-0f3e12693388","type":0}}',
        '{"store":"rideAttendee","value":{"attendee":"2fe1252a-63b3-4e90-b269-3c4d3a154da2","date":"2026-10-24T00:00:00.000","isScanned":false}}',
      ]);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('migrator ignores records without a store name', () async {
      await writeLinesToOldDatabaseFile([
        '{"version":1,"sembast":1}',
        '{"key":"2026-10-17T00:00:00.000","value":{"scannedAttendees":null}}',
        '{"key":"2fe1252a-63b3-4e90-b269-3c4d3a154da2","value":{"active":true,"alias":"J","firstname":"R","lastname":"B","lastUpdated":"2026-10-18 10:02:02.78","profile":null}}',
        '{"key":"2026-10-17T19:42:10.794028","value":{"deviceName":"device1","owner":"59954196-d883-4477-b612-0f3e12693388","type":0}}',
        '{"key":"2026-10-24T00:00:00.0002fe1252a-63b3-4e90-b269-3c4d3a154da2","value":{"attendee":"2fe1252a-63b3-4e90-b269-3c4d3a154da2","date":"2026-10-24T00:00:00.000","isScanned":false}}',
      ]);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('migrator ignores records without a record value', () async {
      await writeLinesToOldDatabaseFile([
        '{"version":1,"sembast":1}',
        '{"key":"2026-10-17T00:00:00.000","store":"ride"}',
        '{"key":"2fe1252a-63b3-4e90-b269-3c4d3a154da2","store":"member"}',
        '{"key":"2026-10-17T19:42:10.794028","store":"device"}',
        '{"key":"2026-10-24T00:00:00.0002fe1252a-63b3-4e90-b269-3c4d3a154da2","store":"rideAttendee"}',
      ]);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    test('migrator ignores deleted records', () async {
      await writeLinesToOldDatabaseFile([
        '{"version":1,"sembast":1}',
        '{"key":"2026-10-18T10:01:40.029397","deleted":true,"store":"ride"}',
        '{"key":"2026-10-18T10:01:40.029397","deleted":true,"store":"member"}',
        '{"key":"2026-10-18T10:01:40.029397","deleted":true,"store":"device"}',
        '{"key":"2026-10-18T10:01:40.029397","deleted":true,"store":"rideAttendee"}',
      ]);

      final DatabaseMigrator migrator = createMigrator(database, fileSystem);

      await migrator.migrate();

      await expectDatabaseIsEmpty(database);
      expect(oldDatabaseFile.existsSync(), isFalse);
    });

    group('ride records', () {
      test('ignores ride record with invalid timestamp key', () async {
        await writeLinesToOldDatabaseFile([
          '{"version":1,"sembast":1}',
          '{"key":"","store":"ride","value":{"scannedAttendees":null}}',
        ]);

        final DatabaseMigrator migrator = createMigrator(database, fileSystem);

        await migrator.migrate();

        await expectDatabaseIsEmpty(database);
        expect(oldDatabaseFile.existsSync(), isFalse);
      });

      test('ignores ride record with invalid value', () async {
        await writeLinesToOldDatabaseFile([
          '{"version":1,"sembast":1}',
          '{"key":"2026-10-17T00:00:00.000","store":"ride","value":{"scannedAttendees":""}}',
          '{"key":"2026-10-17T00:00:00.001","store":"ride","value":1}',
          '{"key":"2026-10-17T00:00:00.002","store":"ride","value":{"scannedAttendees":-1}}',
        ]);

        final DatabaseMigrator migrator = createMigrator(database, fileSystem);

        await migrator.migrate();

        await expectDatabaseIsEmpty(database);
        expect(oldDatabaseFile.existsSync(), isFalse);
      });
    });
  });
}
