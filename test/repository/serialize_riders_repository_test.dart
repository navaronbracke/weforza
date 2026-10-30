import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
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

  Future<void> addRiders(Iterable<RidersCompanion> riders) async {
    for (final rider in riders) {
      await riderRepository.addRider(rider);
    }
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

        await deviceRepository.addDevice(
          .insert(name: 'Device B', deviceType: .gps, ownerId: rider.id, creationDate: Value(DateTime(2000, 2, 3))),
        );
        await deviceRepository.addDevice(
          .insert(name: 'Device A', deviceType: .phone, ownerId: rider.id, creationDate: Value(DateTime(2000, 2, 3))),
        );

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

          await deviceRepository.addDevice(.insert(deviceType: .gps, name: deviceNames.first, ownerId: rider.id));
          await deviceRepository.addDevice(.insert(deviceType: .gps, name: deviceNames.last, ownerId: rider.id));
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
}
