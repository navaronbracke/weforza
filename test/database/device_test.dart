import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/device/device_type.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

void main() {
  late WeForzaDatabase database;
  late DeviceRepository repository;
  late RiderRepository riderRepository;

  setUp(() async {
    database = WeForzaDatabase.memory();
    repository = DeviceRepository(database);
    riderRepository = RiderRepository(database);

    await Future.wait([
      riderRepository.addRider(.insert(firstName: 'John', lastName: 'Doe', lastUpdated: Value(DateTime(2000)))),
      riderRepository.addRider(.insert(firstName: 'Jane', lastName: 'Roe', lastUpdated: Value(DateTime(2000)))),
    ]);
  });

  tearDown(() => database.close());

  Future<List<Device>> addDevices(Iterable<DevicesCompanion> devices) async {
    return Future.wait([for (final device in devices) repository.addDevice(device)]);
  }

  DevicesCompanion deviceFor({
    required String name,
    required int ownerId,
    DeviceType type = .phone,
    DateTime? created,
  }) {
    return .insert(name: name, ownerId: ownerId, deviceType: type, creationDate: Value.absentIfNull(created));
  }

  Future<List<Device>> getAllDevices() => repository.getAllDevices();

  Future<List<Rider>> getAllRiders() => riderRepository.getRiders(.all);

  Future<Rider> getRider(int id) async {
    final riders = await getAllRiders();

    return riders.firstWhere((r) => r.id == id);
  }

  group('addDevice', () {
    test('inserts and returns the device', () async {
      final john = (await getAllRiders()).firstWhere((r) => r.firstName == 'John');

      final devices = await addDevices([deviceFor(name: 'Pixel', ownerId: john.id, type: .gps)]);
      final device = devices.first;

      expect(device.id, 1);
      expect(device.name, 'Pixel');
      expect(device.ownerId, john.id);
      expect(device.deviceType, DeviceType.gps);
    });

    test('updates the owner lastUpdated', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      final jane = riders.firstWhere((r) => r.firstName == 'Jane');

      await addDevices([deviceFor(name: 'Pixel', ownerId: john.id)]);

      expect((await getRider(john.id)).lastUpdated.isAfter(DateTime(2000)), isTrue);
      expect((await getRider(jane.id)).lastUpdated, DateTime(2000));
    });

    test('throws DeviceExistsException for the same name and owner', () async {
      final john = (await getAllRiders()).firstWhere((r) => r.firstName == 'John');
      await addDevices([deviceFor(name: 'Pixel', ownerId: john.id)]);

      expect(() => addDevices([deviceFor(name: 'Pixel', ownerId: john.id)]), throwsA(isA<DeviceExistsException>()));
    });

    test('allows the same name for different owners', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      final jane = riders.firstWhere((r) => r.firstName == 'Jane');

      await addDevices([deviceFor(name: 'Pixel', ownerId: john.id), deviceFor(name: 'Pixel', ownerId: jane.id)]);

      expect(await getAllDevices(), hasLength(2));
    });

    test('fails for a non-existent owner', () async {
      expect(() => repository.addDevice(deviceFor(name: 'Pixel', ownerId: 99)), throwsA(isA<Exception>()));
    });
  });

  group('getAllDevices', () {
    test('returns all devices', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      final jane = riders.firstWhere((r) => r.firstName == 'Jane');

      await addDevices([
        deviceFor(name: 'Pixel', ownerId: john.id),
        deviceFor(name: 'Watch', ownerId: john.id, type: .watch),
        deviceFor(name: 'Pixel', ownerId: jane.id),
      ]);

      final devices = await getAllDevices();

      expect(devices, hasLength(3));
      expect(devices[0].name, 'Pixel');
      expect(devices[0].ownerId, john.id);
      expect(devices[0].deviceType, DeviceType.phone);
      expect(devices[1].name, 'Watch');
      expect(devices[1].ownerId, john.id);
      expect(devices[1].deviceType, DeviceType.watch);
      expect(devices[2].name, 'Pixel');
      expect(devices[2].ownerId, jane.id);
      expect(devices[2].deviceType, DeviceType.phone);
    });

    test('returns empty list when no devices exist', () async {
      expect(await getAllDevices(), isEmpty);
    });
  });

  group('getAllDevicesGroupedByOwnerId', () {
    test('groups devices by owner id', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      final jane = riders.firstWhere((r) => r.firstName == 'Jane');

      await addDevices([
        deviceFor(name: 'Pixel', ownerId: john.id),
        deviceFor(name: 'Watch', ownerId: john.id, type: .watch),
        deviceFor(name: 'Pixel', ownerId: jane.id),
      ]);

      final grouped = await repository.getAllDevicesGroupedByOwnerId();
      expect(grouped, {
        john.id: {'Pixel', 'Watch'},
        jane.id: {'Pixel'},
      });
    });

    test('returns empty map when no devices exist', () async {
      expect(await repository.getAllDevicesGroupedByOwnerId(), isEmpty);
    });
  });

  group('getOwnerDevices', () {
    test('returns only devices of the owner', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      final jane = riders.firstWhere((r) => r.firstName == 'Jane');

      await addDevices([
        deviceFor(name: 'Pixel', ownerId: john.id),
        deviceFor(name: 'Watch', ownerId: john.id, type: .watch),
        deviceFor(name: 'Pixel', ownerId: jane.id),
      ]);

      final [johnDevices, janeDevices] = await Future.wait([
        repository.getOwnerDevices(john.id),
        repository.getOwnerDevices(jane.id),
      ]);

      expect(johnDevices, hasLength(2));
      expect(johnDevices[0].ownerId, john.id);
      expect(johnDevices[0].name, 'Pixel');
      expect(johnDevices[0].deviceType, DeviceType.phone);
      expect(johnDevices[1].ownerId, john.id);
      expect(johnDevices[1].name, 'Watch');
      expect(johnDevices[1].deviceType, DeviceType.watch);

      expect(janeDevices, hasLength(1));
      expect(janeDevices[0].ownerId, jane.id);
      expect(janeDevices[0].name, 'Pixel');
      expect(janeDevices[0].deviceType, DeviceType.phone);
    });

    test('returns empty list when owner has no devices', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');

      expect(await repository.getOwnerDevices(john.id), isEmpty);
    });

    test('returns empty list for non-existent owner', () async {
      expect(await repository.getOwnerDevices(99), isEmpty);
    });
  });

  group('deleteDevice', () {
    test('deletes the device and updates the owner last updated time', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');

      final added = await addDevices([
        deviceFor(name: 'Pixel', ownerId: john.id),
        deviceFor(name: 'Watch', ownerId: john.id),
      ]);

      // Ensure the last update timestamp is deterministic.
      await (database.update(
        database.riders,
      )..where((rider) => rider.id.equals(john.id))).write(RidersCompanion(lastUpdated: Value(DateTime(2000, 2, 2))));

      await repository.deleteDevice(added.first);

      expect((await getAllDevices()).single.name, 'Watch');
      expect((await getRider(1)).lastUpdated.isAfter(DateTime(2000, 2, 2)), isTrue);
    });

    test('does nothing if the device does not exist', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      await addDevices([deviceFor(name: 'Pixel', ownerId: john.id), deviceFor(name: 'Watch', ownerId: john.id)]);

      final initialDevices = await getAllDevices();
      final lastUpdatedBeforeDelete = (await getRider(john.id)).lastUpdated;
      await repository.deleteDevice(
        Device(id: 999, creationDate: DateTime.now(), name: 'd', ownerId: john.id, deviceType: .phone),
      );
      final finalDevices = await getAllDevices();
      expect(finalDevices, initialDevices);

      expect((await getRider(john.id)).lastUpdated, lastUpdatedBeforeDelete);
    });

    test('only removes the specific device', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      final jane = riders.firstWhere((r) => r.firstName == 'Jane');

      final johnDevices = await addDevices([
        deviceFor(name: 'Pixel', ownerId: john.id),
        deviceFor(name: 'Watch', ownerId: john.id),
      ]);
      final janeDevices = await addDevices([deviceFor(name: 'Pixel', ownerId: jane.id)]);

      await repository.deleteDevice(johnDevices.first);

      final allDevices = await getAllDevices();
      expect(allDevices, contains(johnDevices.last));
      expect(allDevices, contains(janeDevices.first));
      expect(allDevices, isNot(contains(johnDevices.first)));
    });
  });

  group('updateDevice', () {
    test('updates the device and returns it', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');

      final added = await addDevices([deviceFor(name: 'Pixel', ownerId: john.id)]);
      final addedDevice = added.first;

      final updated = await repository.updateDevice(
        DevicesCompanion(
          id: Value(addedDevice.id),
          name: const Value('Watch'),
          ownerId: Value(addedDevice.ownerId),
          deviceType: const Value(.watch),
          creationDate: Value(addedDevice.creationDate),
        ),
      );

      expect(updated.id, addedDevice.id);
      expect(updated.ownerId, addedDevice.ownerId);
      expect(updated.name, 'Watch');
      expect(updated.deviceType, DeviceType.watch);
      expect(await repository.getAllDevices(), hasLength(1));
    });

    test('throws if device name collides with another device of the same owner', () async {
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');

      final devices = await addDevices([
        deviceFor(name: 'Pixel', ownerId: john.id),
        deviceFor(name: 'Watch', ownerId: john.id),
      ]);

      final deviceToUpdate = devices.last;

      await expectLater(
        repository.updateDevice(
          DevicesCompanion(
            id: Value(deviceToUpdate.id),
            name: const Value('Pixel'),
            ownerId: Value(deviceToUpdate.ownerId),
            deviceType: const Value(.watch),
            creationDate: Value(deviceToUpdate.creationDate),
          ),
        ),
        throwsA(isA<DeviceExistsException>()),
      );
    });
  });
}
