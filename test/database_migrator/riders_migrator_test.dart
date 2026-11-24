import 'package:drift/drift.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/database_migrator.dart';
import 'package:weforza/database/riders.dart';

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

  test('skips deleted riders', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"123","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"456","store":"member","deleted":true}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.riders.count().getSingle(), 1);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('skips riders without a store name', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"123","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.riders.count().getSingle(), 0);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('skips riders without a key', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.riders.count().getSingle(), 0);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('skips riders with an invalid key', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":" ","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":1,"store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.riders.count().getSingle(), 0);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('skips riders with an invalid value', () async {
    final nameAndAliasMax = Riders.nameAndAliasLength.max;

    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"1","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"2","store":"member"}',
      '{"key":"3","store":"member","value":null',
      '{"key":"4","store":"member","value":1',
      '{"key":"5","store":"member","value":{}',
      '{"key":"6","store":"member","value":{"active":true,"alias":"","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"7","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"8","store":"member","value":{"active":true,"alias":"","firstname":"","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"9","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"10","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":"","profile":null}}',
      '{"key":"11","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","profile":null}}',
      '{"key":"12","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":null,"profile":null}}',
      '{"key":"13","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":{},"profile":null}}',
      '{"key":"14","store":"member","value":{"active":true,"alias":1,"firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"15","store":"member","value":{"active":true,"alias":[],"firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"16","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":1}}',
      '{"key":"17","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":"foo"}}',
      '{"key":"18","store":"member","value":{"active":true,"alias":"","firstname":"${'A' * nameAndAliasMax + 'a'}","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"19","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"${'A' * nameAndAliasMax + 'a'}","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"20","store":"member","value":{"active":true,"alias":"${'A' * nameAndAliasMax + 'a'}","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"21","store":"member","value":{"active":true,"alias":"","firstname":" ","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"22","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":" ","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"23","store":"member","value":{"active":true,"alias":" ","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"24","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth&","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"25","store":"member","value":{"active":true,"alias":"","firstname":"Kenneth","lastname":"Saey&","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"26","store":"member","value":{"active":true,"alias":"&","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    expect(await database.riders.count().getSingle(), 1);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('migrates riders', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"a","store":"member","value":{"active":true,"alias":"KS","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
      '{"key":"b","store":"member","value":{"active":false,"alias":"","firstname":"John","lastname":"Smith","lastUpdated":"2026-10-19 10:01:44.00","profile":"file:///data/user/0/be.weforza.app/1.jpg"}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final riders = await database.riders.select().get();

    expect(riders, [
      Rider(
        id: 1,
        firstName: 'Kenneth',
        lastName: 'Saey',
        alias: 'KS',
        isActive: true,
        lastUpdated: DateTime.parse('2026-10-18T10:01:40.000'),
      ),
      Rider(
        id: 2,
        firstName: 'John',
        lastName: 'Smith',
        alias: '',
        isActive: false,
        lastUpdated: DateTime.parse('2026-10-19T10:01:44.000'),
        profileImageUri: Uri.parse('file:///data/user/0/be.weforza.app/1.jpg'),
      ),
    ]);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('treats missing isActive as default value', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"a","store":"member","value":{"alias":"KS","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final riders = await database.riders.select().get();

    expect(riders, [
      Rider(
        id: 1,
        firstName: 'Kenneth',
        lastName: 'Saey',
        alias: 'KS',
        isActive: true,
        lastUpdated: DateTime.parse('2026-10-18 10:01:40.03'),
      ),
    ]);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('treats missing alias as the empty string', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"a","store":"member","value":{"active":true,"firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03","profile":null}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final riders = await database.riders.select().get();

    expect(riders, [
      Rider(
        id: 1,
        firstName: 'Kenneth',
        lastName: 'Saey',
        alias: '',
        isActive: true,
        lastUpdated: DateTime.parse('2026-10-18 10:01:40.03'),
      ),
    ]);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });

  test('treats misisng profile image as null', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"a","store":"member","value":{"active":true,"alias":"KS","firstname":"Kenneth","lastname":"Saey","lastUpdated":"2026-10-18 10:01:40.03"}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final riders = await database.riders.select().get();

    expect(riders, [
      Rider(
        id: 1,
        firstName: 'Kenneth',
        lastName: 'Saey',
        alias: 'KS',
        isActive: true,
        lastUpdated: DateTime.parse('2026-10-18 10:01:40.03'),
      ),
    ]);
    expect(oldDatabaseFile.existsSync(), isFalse);
  });
}
