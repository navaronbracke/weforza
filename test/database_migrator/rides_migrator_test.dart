import 'package:drift/drift.dart';
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

  test('skips deleted rides', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"2026-10-01T00:00:00.000","deleted":true,"store":"ride"}',
      '{"key":"2026-10-02T00:00:00.000","store":"ride","value":{"scannedAttendees":0}}',
      '{"key":"2026-10-03T00:00:00.000","store":"ride","value":{"scannedAttendees":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.rides.count().getSingle(), 2);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('skips ride without a valid store name', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"2026-10-01T00:00:00.000","value":{"scannedAttendees":null}}',
      '{"key":"2026-10-02T00:00:00.000","store":"rideFoo","value":{"scannedAttendees":null}}',
      '{"key":"2026-10-03T00:00:00.000","store":"","value":{"scannedAttendees":null}}',
      '{"key":"2026-10-04T00:00:00.000","store":1,"value":{"scannedAttendees":null}}',
      '{"key":"2026-10-05T00:00:00.000","store":[],"value":{"scannedAttendees":null}}',
      '{"key":"2026-10-06T00:00:00.000","store":"ride","value":{"scannedAttendees":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.rides.count().getSingle(), 1);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('skips ride without a key', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"store":"ride","value":{"scannedAttendees":null}}',
      '{"key":"2026-10-01T00:00:00.000","store":"ride","value":{"scannedAttendees":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.rides.count().getSingle(), 1);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('skips ride with an invalid timestamp key', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"","store":"ride","value":{"scannedAttendees":null}}}',
      '{"key":"foo","store":"ride","value":{"scannedAttendees":null}}}',
      '{"key":null,"store":"ride","value":{"scannedAttendees":null}}}',
      '{"key":[],"store":"ride","value":{"scannedAttendees":null}}}',
      '{"key":"2026-10-01T00:00:00.000","store":"ride","value":{"scannedAttendees":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.rides.count().getSingle(), 1);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('skips rides with an invalid value', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"2026-10-01T00:00:00.000","store":"ride","value":{"scannedAttendees":null}}',
      '{"key":"2026-10-02T00:00:00.000","store":"ride"}',
      '{"key":"2026-10-03T00:00:00.000","store":"ride","value":null}',
      '{"key":"2026-10-04T00:00:00.000","store":"ride","value":{1}}',
      '{"key":"2026-10-05T00:00:00.000","store":"ride","value":{"foo":null}}',
      '{"key":"2026-10-06T00:00:00.000","store":"ride","value":{"scannedAttendees":""}}',
      '{"key":"2026-10-07T00:00:00.000","store":"ride","value":{"scannedAttendees":[]}}',
      '{"key":"2026-10-08T00:00:00.000","store":"ride","value":{"scannedAttendees":-1}}',
      '{"key":"2026-10-09T00:00:00.000","store":"ride","value":{"scannedAttendees":0.0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.rides.count().getSingle(), 1);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('migrates rides', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"2026-10-01T00:00:00.000","store":"ride","value":{"scannedAttendees":0}}',
      '{"key":"2026-10-02T00:00:00.000","store":"ride","value":{"scannedAttendees":null}}',
      '{"key":"2026-10-03T00:00:00.000","store":"ride","value":{"scannedAttendees":10}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final rides = await database.rides.select().get();
    expect(rides, [
      Ride(id: 1, date: DateTime.parse('2026-10-01T00:00:00.000'), scannedAttendees: 0),
      Ride(id: 2, date: DateTime.parse('2026-10-02T00:00:00.000')),
      Ride(id: 3, date: DateTime.parse('2026-10-03T00:00:00.000'), scannedAttendees: 10),
    ]);

    expect(oldDatabaseFile.existsSync(), isFalse);
  });
}
