import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/database_migrator.dart';
import 'package:weforza/database/devices.dart';
import 'package:weforza/model/device/device_type.dart';

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

  test('skips deleted devices', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"2026-10-21T10:00:00.000","deleted":true,"store":"device"}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 1);
  });

  test('skips devices without a valid store name', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"deviceFoo","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"2026-10-21T19:43:00.000","store":"","value":{"deviceName":"device2","owner":"abc","type":0}}',
      '{"key":"2026-10-22T19:44:00.000","store":[],"value":{"deviceName":"device3","owner":"abc","type":0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 0);
  });

  test('skips devices without a key', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"store":"device","value":{"deviceName":"device2","owner":"abc","type":0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 1);
  });

  test('skips devices with an invalid key', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"","store":"device","value":{"deviceName":"device2","owner":"abc","type":0}}',
      '{"key":"abc","store":"device","value":{"deviceName":"device3","owner":"abc","type":0}}',
      '{"key":"123","store":"device","value":{"deviceName":"device4","owner":"abc","type":0}}',
      '{"key":123,"store":"device","value":{"deviceName":"device5","owner":"abc","type":0}}',
      '{"key":[],"store":"device","value":{"deviceName":"device6","owner":"abc","type":0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 1);
  });

  test('skips devices without a value', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device"}',
      '{"key":"2026-10-22T19:42:00.000","store":"device","value":null}',
      '{"key":"2026-10-23T19:42:00.000","store":"device","value":{}}',
      '{"key":"2026-10-24T19:42:00.000","store":"device","value":[]}',
      '{"key":"2026-10-25T19:42:00.000","store":"device","value":1}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 1);
  });

  test('skips devices without a valid owner id', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device","value":{"deviceName":"device2","type":0}}',
      '{"key":"2026-10-22T19:42:00.000","store":"device","value":{"deviceName":"device3","owner":"def","type":0}}',
      '{"key":"2026-10-23T19:42:00.000","store":"device","value":{"deviceName":"device4","owner":"","type":0}}',
      '{"key":"2026-10-24T19:42:00.000","store":"device","value":{"deviceName":"device5","owner":123,"type":0}}',
      '{"key":"2026-10-25T19:42:00.000","store":"device","value":{"deviceName":"device6","owner":null,"type":0}}',
      '{"key":"2026-10-26T19:42:00.000","store":"device","value":{"deviceName":"device7","owner":[],"type":0}}',
      '{"key":"2026-10-27T19:42:00.000","store":"device","value":{"deviceName":"device8","owner":" ","type":0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 1);
  });

  test('skips devices without a device name', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device","value":{"owner":"abc","type":0}}',
      '{"key":"2026-10-22T19:42:00.000","store":"device","value":{"deviceName":"","owner":"abc","type":0}}',
      '{"key":"2026-10-23T19:42:00.000","store":"device","value":{"deviceName":1,"owner":"abc","type":0}}',
      '{"key":"2026-10-24T19:42:00.000","store":"device","value":{"deviceName":[],"owner":"abc","type":0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 1);
  });

  test('skips devices with a blank device name', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device","value":{"deviceName":" ","owner":"abc","type":0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 1);
  });

  test('skips devices with a too long device name', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device","value":{"deviceName":"A${'a' * Devices.nameLength.max}","owner":"abc","type":0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 1);
  });

  test('skips devices with invalid characters in device name', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device","value":{"deviceName":"A,","owner":"abc","type":0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 1);
  });

  test('ignores unknown device types', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":0}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device","value":{"deviceName":"device2","owner":"abc","type":-1}}',
      '{"key":"2026-10-22T19:42:00.000","store":"device","value":{"deviceName":"device3","owner":"abc","type":${DeviceType.values.length}}}',
      '{"key":"2026-10-23T19:42:00.000","store":"device","value":{"deviceName":"device4","owner":"abc","type":999}}',
      '{"key":"2026-10-24T19:42:00.000","store":"device","value":{"deviceName":"device5","owner":"abc","type":""}}',
      '{"key":"2026-10-25T19:42:00.000","store":"device","value":{"deviceName":"device6","owner":"abc","type":null}}',
      '{"key":"2026-10-26T19:42:00.000","store":"device","value":{"deviceName":"device7","owner":"abc","type":{}}}',
      '{"key":"2026-10-27T19:42:00.000","store":"device","value":{"deviceName":"device8","owner":"abc","type":1.0}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final devices = await database.select(database.devices).get();

    expect(devices.length, 8);
    expect(devices[0].deviceType, DeviceType.unknown);
    expect(devices[1].deviceType, DeviceType.unknown);
    expect(devices[2].deviceType, DeviceType.unknown);
    expect(devices[3].deviceType, DeviceType.unknown);
    expect(devices[4].deviceType, DeviceType.unknown);
    expect(devices[5].deviceType, DeviceType.unknown);
    expect(devices[6].deviceType, DeviceType.unknown);
    expect(devices[7].deviceType, DeviceType.unknown);
  });

  test('migrates devices of single owner', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":1}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device","value":{"deviceName":"device2","owner":"abc","type":2}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final riders = await database.select(database.riders).get();
    final devices = await database.select(database.devices).get();

    expect(riders.length, 1);

    expect(devices, [
      Device(id: 1, deviceType: .pulseMonitor, name: 'device1', ownerId: riders.first.id),
      Device(id: 2, deviceType: .powerMeter, name: 'device2', ownerId: riders.first.id),
    ]);
  });

  test('migrates devices of multiple owners', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"def","store":"member","value":{"active":true,"alias":"","firstname":"Jane","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"john1","owner":"abc","type":1}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device","value":{"deviceName":"john2","owner":"abc","type":2}}',
      '{"key":"2026-10-22T19:42:00.000","store":"device","value":{"deviceName":"jane1","owner":"def","type":3}}',
      '{"key":"2026-10-23T19:42:00.000","store":"device","value":{"deviceName":"jane2","owner":"def","type":4}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final riders = await database.select(database.riders).get();
    final devices = await database.select(database.devices).get();

    expect(riders.length, 2);

    expect(devices, [
      Device(id: 1, deviceType: .pulseMonitor, name: 'john1', ownerId: riders.first.id),
      Device(id: 2, deviceType: .powerMeter, name: 'john2', ownerId: riders.first.id),
      Device(id: 3, deviceType: .cadenceMeter, name: 'jane1', ownerId: riders.last.id),
      Device(id: 4, deviceType: .watch, name: 'jane2', ownerId: riders.last.id),
    ]);
  });

  test('allows multiple owners for a device with the same name', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"def","store":"member","value":{"active":true,"alias":"","firstname":"Jane","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":1}}',
      '{"key":"2026-10-22T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"def","type":1}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final riders = await database.select(database.riders).get();
    final devices = await database.select(database.devices).get();

    expect(riders.length, 2);

    expect(devices, [
      Device(id: 1, deviceType: .pulseMonitor, name: 'device1', ownerId: riders.first.id),
      Device(id: 2, deviceType: .pulseMonitor, name: 'device1', ownerId: riders.last.id),
    ]);
  });

  test('does not add duplicate device names for the same owner', () async {
    await writeLinesToOldDatabaseFile([
      '{"version":1,"sembast":1}',
      '{"key":"abc","store":"member","value":{"active":true,"alias":"","firstname":"John","lastname":"Doe","lastUpdated":"2026-10-18 10:00:00.00","profile":null}}',
      '{"key":"2026-10-20T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":1}}',
      '{"key":"2026-10-21T19:42:00.000","store":"device","value":{"deviceName":"device1","owner":"abc","type":1}}',
    ], oldDatabaseFile);

    final DatabaseMigrator migrator = createMigrator(database, fileSystem, oldDatabaseDirectory);

    await migrator.migrate();

    final riders = await database.select(database.riders).get();
    final devices = await database.select(database.devices).get();

    expect(riders.length, 1);

    expect(devices, [Device(id: 1, deviceType: .pulseMonitor, name: 'device1', ownerId: riders.first.id)]);
  });
}
