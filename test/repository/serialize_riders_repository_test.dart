import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/devices.dart';
import 'package:weforza/database/riders.dart';
import 'package:weforza/model/device/device_type.dart';
import 'package:weforza/model/export/exportable_rider.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/rider_repository.dart';
import 'package:weforza/repository/serialize_riders_repository.dart';

void main() {
  late WeForzaDatabase database;
  late DeviceRepository deviceRepository;
  late RiderRepository riderRepository;
  late SerializeRidersRepository serializeRidersRepository;

  setUp(() {
    database = WeForzaDatabase.memory();
    deviceRepository = DeviceRepository(database);
    riderRepository = RiderRepository(database);
    serializeRidersRepository = SerializeRidersRepository(database);
  });

  tearDown(() => database.close());

  Future<void> addDevices(Iterable<DevicesCompanion> devices) {
    return Future.wait([for (final device in devices) deviceRepository.addDevice(device)]);
  }

  Future<void> addRiders(Iterable<RidersCompanion> riders) {
    return Future.wait([for (final rider in riders) riderRepository.addRider(rider)]);
  }

  group('getExportableRiders', () {
    test('returns nothing if there are no riders', () async {
      expect(await serializeRidersRepository.getExportableRiders(), isEmpty);
    });

    group('returns single rider', () {
      test('without devices', () async {
        await addRiders([
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            alias: const Value('J'),
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
        ]);

        final exportableRiders = await serializeRidersRepository.getExportableRiders();
        expect(exportableRiders, hasLength(1));
        expect(exportableRiders.single.firstName, 'John');
        expect(exportableRiders.single.lastName, 'Doe');
        expect(exportableRiders.single.alias, 'J');
        expect(exportableRiders.single.isActive, isTrue);
        expect(exportableRiders.single.lastUpdated, DateTime.utc(2000, 2, 3));
        expect(exportableRiders.single.devices, isEmpty);
      });

      test('and sorts devices on name', () async {
        await addRiders([
          .insert(firstName: 'John', lastName: 'Doe', alias: const Value('J'), isActive: const Value(true)),
        ]);

        final riders = await riderRepository.getRiders(.all);
        final rider = riders.first;

        await addDevices([
          .insert(name: 'Device B', deviceType: .gps, ownerId: rider.id),
          .insert(name: 'Device A', deviceType: .phone, ownerId: rider.id),
        ]);

        final exportableRiders = await serializeRidersRepository.getExportableRiders();
        expect(exportableRiders, hasLength(1));
        expect(exportableRiders.single.devices, {'Device A', 'Device B'});
      });

      test('without alias', () async {
        await addRiders([
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
        ]);

        final exportableRiders = await serializeRidersRepository.getExportableRiders();
        expect(exportableRiders, hasLength(1));
        expect(exportableRiders.single.firstName, 'John');
        expect(exportableRiders.single.lastName, 'Doe');
        expect(exportableRiders.single.alias, '');
        expect(exportableRiders.single.isActive, isTrue);
        expect(exportableRiders.single.lastUpdated, DateTime.utc(2000, 2, 3));
        expect(exportableRiders.single.devices, isEmpty);
      });

      test('with empty alias', () async {
        await addRiders([
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            alias: const Value(''),
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
        ]);

        final exportableRiders = await serializeRidersRepository.getExportableRiders();
        expect(exportableRiders, hasLength(1));
        expect(exportableRiders.single.firstName, 'John');
        expect(exportableRiders.single.lastName, 'Doe');
        expect(exportableRiders.single.alias, '');
        expect(exportableRiders.single.isActive, isTrue);
        expect(exportableRiders.single.lastUpdated, DateTime.utc(2000, 2, 3));
        expect(exportableRiders.single.devices, isEmpty);
      });
    });

    group('retuns many riders', () {
      test('without devices, sorted on rider first name, last name and alias', () async {
        await addRiders([
          .insert(
            firstName: 'Alice',
            lastName: 'Roe',
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            alias: const Value('J'),
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
          .insert(
            firstName: 'Jane',
            lastName: 'Doe',
            alias: const Value('J'),
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
          .insert(
            firstName: 'Jane',
            lastName: 'Doe',
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
          .insert(
            firstName: 'Alice',
            lastName: 'Doe',
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
        ]);

        final exportableRiders = await serializeRidersRepository.getExportableRiders();
        final expected = [
          ExportableRider(
            firstName: 'Alice',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2000, 2, 3),
            devices: const {},
          ),
          ExportableRider(
            firstName: 'Alice',
            lastName: 'Roe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2000, 2, 3),
            devices: const {},
          ),
          ExportableRider(
            firstName: 'Jane',
            lastName: 'Doe',
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2000, 2, 3),
            devices: const {},
          ),
          ExportableRider(
            firstName: 'Jane',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2000, 2, 3),
            devices: const {},
          ),
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2000, 2, 3),
            devices: const {},
          ),
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2000, 2, 3),
            devices: const {},
          ),
        ];

        expect(exportableRiders, expected);
      });

      test('with devices, sorted on rider name and device name', () async {
        await addRiders([
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            alias: const Value('J'),
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
          .insert(
            firstName: 'Jane',
            lastName: 'Doe',
            alias: const Value('J'),
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
          .insert(
            firstName: 'Jane',
            lastName: 'Doe',
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
          .insert(
            firstName: 'Alice',
            lastName: 'Doe',
            isActive: const Value(true),
            lastUpdated: Value(DateTime.utc(2000, 2, 3)),
          ),
        ]);

        final riders = await riderRepository.getRiders(.all);

        for (final rider in riders) {
          const deviceNames = {'Foo', 'Bar'};

          await addDevices([
            .insert(deviceType: .gps, name: deviceNames.first, ownerId: rider.id),
            .insert(deviceType: .gps, name: deviceNames.last, ownerId: rider.id),
          ]);
        }

        final updatedRiders = await riderRepository.getRiders(.all);
        final exportedRiders = await serializeRidersRepository.getExportableRiders();
        final expected = [
          ExportableRider(
            firstName: 'Alice',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: updatedRiders.where((r) => r.firstName == 'Alice' && r.lastName == 'Doe').first.lastUpdated,
            devices: const {'Bar', 'Foo'},
          ),
          ExportableRider(
            firstName: 'Jane',
            lastName: 'Doe',
            alias: 'J',
            isActive: true,
            lastUpdated: updatedRiders
                .where((r) => r.firstName == 'Jane' && r.lastName == 'Doe' && r.alias == 'J')
                .first
                .lastUpdated,
            devices: const {'Bar', 'Foo'},
          ),
          ExportableRider(
            firstName: 'Jane',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: updatedRiders
                .where((r) => r.firstName == 'Jane' && r.lastName == 'Doe' && r.alias == null)
                .first
                .lastUpdated,
            devices: const {'Bar', 'Foo'},
          ),
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'J',
            isActive: true,
            lastUpdated: updatedRiders
                .where((r) => r.firstName == 'John' && r.lastName == 'Doe' && r.alias == 'J')
                .first
                .lastUpdated,
            devices: const {'Bar', 'Foo'},
          ),
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: updatedRiders
                .where((r) => r.firstName == 'John' && r.lastName == 'Doe' && r.alias == null)
                .first
                .lastUpdated,
            devices: const {'Bar', 'Foo'},
          ),
        ];

        expect(exportedRiders, expected);
      });
    });
  });

  group('saveExportableRiders', () {
    test('does nothing if empty', () async {
      await serializeRidersRepository.saveExportableRiders([]);

      expect(await riderRepository.getRiders(.all), isEmpty);
      expect(await deviceRepository.getAllDevicesGroupedByOwnerId(), isEmpty);
    });

    group('with single rider', () {
      test('saves single rider without alias', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: null,
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        final riders = await riderRepository.getRiders(.all);

        expect(riders, hasLength(1));
        expect(riders.first.firstName, 'John');
        expect(riders.first.lastName, 'Doe');
        expect(riders.first.alias, isNull);
        expect(riders.first.isActive, isTrue);
        expect(riders.first.lastUpdated.isAfter(DateTime.utc(2024)), isTrue);
      });

      test('saves single rider with empty alias', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        final riders = await riderRepository.getRiders(.all);

        expect(riders, hasLength(1));
        expect(riders.first.firstName, 'John');
        expect(riders.first.lastName, 'Doe');
        expect(riders.first.alias, isNull);
        expect(riders.first.isActive, isTrue);
        expect(riders.first.lastUpdated.isAfter(DateTime.utc(2024)), isTrue);
      });

      test('saves single rider with blank alias', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: ' ',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        final riders = await riderRepository.getRiders(.all);

        expect(riders, hasLength(1));
        expect(riders.first.firstName, 'John');
        expect(riders.first.lastName, 'Doe');
        expect(riders.first.alias, isNull);
        expect(riders.first.isActive, isTrue);
        expect(riders.first.lastUpdated.isAfter(DateTime.utc(2024)), isTrue);
      });

      test('saves single rider without devices', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        final riders = await riderRepository.getRiders(.all);
        final devices = await deviceRepository.getAllDevices();

        expect(riders, hasLength(1));
        expect(riders.first.firstName, 'John');
        expect(riders.first.lastName, 'Doe');
        expect(riders.first.alias, 'J');
        expect(riders.first.isActive, isTrue);
        expect(riders.first.lastUpdated.isAfter(DateTime.utc(2024)), isTrue);
        expect(devices, isEmpty);
      });

      test('saves rider with devices', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {'Foo', 'Bar'},
          ),
        ]);

        final riders = await riderRepository.getRiders(.all);
        final devices = await deviceRepository.getAllDevices();

        expect(riders, hasLength(1));
        expect(riders.first.firstName, 'John');
        expect(riders.first.lastName, 'Doe');
        expect(riders.first.alias, 'J');
        expect(riders.first.isActive, isTrue);
        expect(riders.first.lastUpdated.isAfter(DateTime.utc(2024)), isTrue);
        expect(devices, hasLength(2));

        expect(devices.first.ownerId, riders.first.id);
        expect(devices.first.deviceType, DeviceType.unknown);
        expect(devices.first.name, 'Foo');
        expect(devices.last.ownerId, riders.first.id);
        expect(devices.last.deviceType, DeviceType.unknown);
        expect(devices.last.name, 'Bar');
      });

      test('does not save rider with first name that is empty', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: '',
            lastName: 'Doe',
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        expect(await riderRepository.getRiders(.all), isEmpty);
      });

      test('does not save rider with first name that is too long', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'A' * (Riders.nameAndAliasLength.max + 1),
            lastName: 'Doe',
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        expect(await riderRepository.getRiders(.all), isEmpty);
      });

      test('does not save rider with first name that has invalid characters', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John#',
            lastName: 'Doe',
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        expect(await riderRepository.getRiders(.all), isEmpty);
      });

      test('does not save rider with last name that is empty', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: '',
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        expect(await riderRepository.getRiders(.all), isEmpty);
      });

      test('does not save rider with last name that is too long', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'A' * (Riders.nameAndAliasLength.max + 1),
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        expect(await riderRepository.getRiders(.all), isEmpty);
      });

      test('does not save rider with last name that has invalid characters', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe#',
            alias: 'J',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        expect(await riderRepository.getRiders(.all), isEmpty);
      });

      test('does not save rider with alias that is too long', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'A' * (Riders.nameAndAliasLength.max + 1),
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        expect(await riderRepository.getRiders(.all), isEmpty);
      });

      test('does not save rider with alias that has invalid characters', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'J#',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {},
          ),
        ]);

        expect(await riderRepository.getRiders(.all), isEmpty);
      });

      test('saves rider but skips devices with empty device name', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {'', ' '},
          ),
        ]);

        final riders = await riderRepository.getRiders(.all);

        expect(riders, hasLength(1));
        expect(riders.first.firstName, 'John');
        expect(riders.first.lastName, 'Doe');
        expect(riders.first.alias, isNull);
        expect(riders.first.isActive, isTrue);
        expect(riders.first.lastUpdated.isAfter(DateTime.utc(2024)), isTrue);

        expect(await deviceRepository.getOwnerDevices(riders.first.id), isEmpty);
      });

      test('saves rider but skips devices with invalid characters in device name', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: const {'Foo,Bar'},
          ),
        ]);

        final riders = await riderRepository.getRiders(.all);

        expect(riders, hasLength(1));
        expect(riders.first.firstName, 'John');
        expect(riders.first.lastName, 'Doe');
        expect(riders.first.alias, isNull);
        expect(riders.first.isActive, isTrue);
        expect(riders.first.lastUpdated.isAfter(DateTime.utc(2024)), isTrue);

        expect(await deviceRepository.getOwnerDevices(riders.first.id), isEmpty);
      });

      test('saves rider but skips devices with too long device name', () async {
        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2024),
            devices: {'F' * (Devices.nameLength.max + 1)},
          ),
        ]);

        final riders = await riderRepository.getRiders(.all);

        expect(riders, hasLength(1));
        expect(riders.first.firstName, 'John');
        expect(riders.first.lastName, 'Doe');
        expect(riders.first.alias, isNull);
        expect(riders.first.isActive, isTrue);
        expect(riders.first.lastUpdated.isAfter(DateTime.utc(2024)), isTrue);

        expect(await deviceRepository.getOwnerDevices(riders.first.id), isEmpty);
      });

      test('does not insert device if already exists for rider', () async {
        await riderRepository.addRider(
          .insert(firstName: 'John', lastName: 'Doe', lastUpdated: Value(DateTime.utc(2024))),
        );

        final existingRider = await riderRepository.getRiders(.all).then((riders) => riders.first);

        await addDevices([.insert(ownerId: existingRider.id, name: 'Device1', deviceType: .gps)]);

        final riderAfterDeviceInsert = await riderRepository.getRiders(.all).then((riders) => riders.first);

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2025),
            devices: const {'Device1'},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, isNull);
        expect(updatedRiders.first.isActive, isTrue);
        expect(updatedRiders.first.lastUpdated.toUtc(), riderAfterDeviceInsert.lastUpdated.toUtc());

        final devices = await deviceRepository.getOwnerDevices(existingRider.id);
        expect(devices, hasLength(1));
        expect(devices.first.name, 'Device1');
      });

      test('does not insert new rider if rider already exists - no alias', () async {
        await riderRepository.addRider(
          .insert(firstName: 'John', lastName: 'Doe', lastUpdated: Value(DateTime.utc(2024))),
        );

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2025),
            devices: const {},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, isNull);
        expect(updatedRiders.first.isActive, isTrue);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2024));
      });

      test('does not insert new rider if rider already exists - with alias', () async {
        await riderRepository.addRider(
          .insert(firstName: 'John', lastName: 'Doe', alias: const Value('JD'), lastUpdated: Value(DateTime.utc(2024))),
        );

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'JD',
            isActive: true,
            lastUpdated: DateTime.utc(2025),
            devices: const {},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, 'JD');
        expect(updatedRiders.first.isActive, isTrue);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2024));
      });

      test('updates existing rider is active state if newer import - no alias', () async {
        await riderRepository.addRider(
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            isActive: const Value(false),
            lastUpdated: Value(DateTime.utc(2024)),
          ),
        );

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2025),
            devices: const {},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, isNull);
        expect(updatedRiders.first.isActive, isTrue);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2025));
      });

      test('updates existing rider is active state if newer import - with alias', () async {
        await riderRepository.addRider(
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            alias: const Value('JD'),
            isActive: const Value(false),
            lastUpdated: Value(DateTime.utc(2024)),
          ),
        );

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'JD',
            isActive: true,
            lastUpdated: DateTime.utc(2025),
            devices: const {},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, 'JD');
        expect(updatedRiders.first.isActive, isTrue);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2025));
      });

      test('does not update existing rider if last update time is older - no alias', () async {
        await riderRepository.addRider(
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            isActive: const Value(false),
            lastUpdated: Value(DateTime.utc(2024)),
          ),
        );

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2023),
            devices: const {},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, isNull);
        expect(updatedRiders.first.isActive, isFalse);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2024));
      });

      test('does not update existing rider if last update time is older - with alias', () async {
        await riderRepository.addRider(
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            alias: const Value('JD'),
            isActive: const Value(false),
            lastUpdated: Value(DateTime.utc(2024)),
          ),
        );

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'JD',
            isActive: true,
            lastUpdated: DateTime.utc(2023),
            devices: const {},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, 'JD');
        expect(updatedRiders.first.isActive, isFalse);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2024));
      });

      test('adds new devices and preserves exsting devices if update time is newer - no alias', () async {
        await riderRepository.addRider(
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            isActive: const Value(false),
            lastUpdated: Value(DateTime.utc(2024)),
          ),
        );

        final rider = (await riderRepository.getRiders(.all)).first;

        await addDevices([.insert(deviceType: .gps, name: 'Device 1', ownerId: rider.id)]);

        // Ensure that the update timestamp is deterministic.
        await (database.update(
          database.riders,
        )..where((row) => row.id.equals(rider.id))).write(RidersCompanion(lastUpdated: Value(DateTime.utc(2024))));

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2025),
            devices: const {'Device 2'},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, isNull);
        expect(updatedRiders.first.isActive, isTrue);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2025));

        final devices = await deviceRepository.getOwnerDevices(updatedRiders.first.id);
        expect(devices.map((d) => d.name), containsAll(['Device 1', 'Device 2']));
      });

      test('adds new devices and preserves exsting devices if update time is newer - with alias', () async {
        await riderRepository.addRider(
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            alias: const Value('JD'),
            isActive: const Value(false),
            lastUpdated: Value(DateTime.utc(2024)),
          ),
        );

        final rider = (await riderRepository.getRiders(.all)).first;

        await addDevices([.insert(deviceType: .gps, name: 'Device 1', ownerId: rider.id)]);

        // Ensure that the update timestamp is deterministic.
        await (database.update(
          database.riders,
        )..where((row) => row.id.equals(rider.id))).write(RidersCompanion(lastUpdated: Value(DateTime.utc(2024))));

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'JD',
            isActive: true,
            lastUpdated: DateTime.utc(2025),
            devices: const {'Device 2'},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, 'JD');
        expect(updatedRiders.first.isActive, isTrue);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2025));

        final devices = await deviceRepository.getOwnerDevices(updatedRiders.first.id);
        expect(devices.map((d) => d.name), containsAll(['Device 1', 'Device 2']));
      });

      test('does not add devices if update time is older - no alias', () async {
        await riderRepository.addRider(
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            isActive: const Value(false),
            lastUpdated: Value(DateTime.utc(2024)),
          ),
        );

        final rider = (await riderRepository.getRiders(.all)).first;

        await addDevices([.insert(deviceType: .gps, name: 'Device 1', ownerId: rider.id)]);

        // Ensure that the update timestamp is deterministic.
        await (database.update(
          database.riders,
        )..where((row) => row.id.equals(rider.id))).write(RidersCompanion(lastUpdated: Value(DateTime.utc(2024))));

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: '',
            isActive: true,
            lastUpdated: DateTime.utc(2023),
            devices: const {'Device 2'},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, isNull);
        expect(updatedRiders.first.isActive, isFalse);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2024));

        final devices = await deviceRepository.getOwnerDevices(updatedRiders.first.id);
        expect(devices, hasLength(1));
      });

      test('does not add devices if update time is older - with alias', () async {
        await riderRepository.addRider(
          .insert(
            firstName: 'John',
            lastName: 'Doe',
            alias: const Value('JD'),
            isActive: const Value(false),
            lastUpdated: Value(DateTime.utc(2024)),
          ),
        );

        final rider = (await riderRepository.getRiders(.all)).first;

        await addDevices([.insert(deviceType: .gps, name: 'Device 1', ownerId: rider.id)]);

        // Ensure that the update timestamp is deterministic.
        await (database.update(
          database.riders,
        )..where((row) => row.id.equals(rider.id))).write(RidersCompanion(lastUpdated: Value(DateTime.utc(2024))));

        await serializeRidersRepository.saveExportableRiders([
          ExportableRider(
            firstName: 'John',
            lastName: 'Doe',
            alias: 'JD',
            isActive: true,
            lastUpdated: DateTime.utc(2023),
            devices: const {'Device 2'},
          ),
        ]);

        final updatedRiders = await riderRepository.getRiders(.all);

        expect(updatedRiders, hasLength(1));
        expect(updatedRiders.first.firstName, 'John');
        expect(updatedRiders.first.lastName, 'Doe');
        expect(updatedRiders.first.alias, 'JD');
        expect(updatedRiders.first.isActive, isFalse);
        expect(updatedRiders.first.lastUpdated.toUtc(), DateTime.utc(2024));

        final devices = await deviceRepository.getOwnerDevices(updatedRiders.first.id);
        expect(devices, hasLength(1));
      });
    });

    // TODO: the above tests for single rider, but with multiple riders
  });
}
