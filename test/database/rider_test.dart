import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

void main() {
  late WeForzaDatabase database;
  late RiderRepository repository;
  late RideRepository rideRepository;

  setUp(() {
    database = WeForzaDatabase.memory();
    repository = RiderRepository(database);
    rideRepository = RideRepository(database);
  });

  tearDown(() => database.close());

  Future<void> addRiders(Iterable<RidersCompanion> riders) {
    return Future.wait(riders.map(repository.addRider));
  }

  Future<List<Rider>> getAllRiders() => repository.getRiders(.all);

  RidersCompanion rider({
    required String firstName,
    required String lastName,
    String? alias,
    bool isActive = true,
    Uri? profileImageUri,
  }) {
    return RidersCompanion.insert(
      firstName: firstName,
      lastName: lastName,
      alias: Value(alias),
      isActive: Value(isActive),
      profileImageUri: profileImageUri == null ? const Value.absent() : Value(profileImageUri),
    );
  }

  group('addRider', () {
    test('inserts a rider with default values', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe')]);

      final riders = await getAllRiders();

      expect(riders, hasLength(1));
      expect(riders.single.id, 1);
      expect(riders.single.firstName, 'John');
      expect(riders.single.lastName, 'Doe');
      expect(riders.single.alias, isNull);
      expect(riders.single.isActive, isTrue);
      expect(riders.single.profileImageUri, isNull);
    });

    test('stores the profile image uri', () async {
      final uri = Uri.file('/path/to/image.png');

      await addRiders([rider(firstName: 'A', lastName: 'B', profileImageUri: uri)]);

      expect((await getAllRiders()).single.profileImageUri, uri);
    });

    test('throws RiderExistsException for a duplicate rider', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe', alias: 'JD')]);

      expect(
        () => repository.addRider(rider(firstName: 'John', lastName: 'Doe', alias: 'JD')),
        throwsA(isA<RiderExistsException>()),
      );
    });

    test('allows the same name with a different alias', () async {
      await addRiders([
        rider(firstName: 'John', lastName: 'Doe', alias: 'JD'),
        rider(firstName: 'John', lastName: 'Doe'),
      ]);

      final riders = await getAllRiders();

      expect(riders, hasLength(2));
      expect(riders.first.firstName, 'John');
      expect(riders.first.lastName, 'Doe');
      expect(riders.first.alias, 'JD');
      expect(riders.last.firstName, 'John');
      expect(riders.last.lastName, 'Doe');
      expect(riders.last.alias, isNull);
    });
  });

  group('deleteRider', () {
    test('deletes only the given rider', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe'), rider(firstName: 'Jane', lastName: 'Roe')]);
      final riders = await getAllRiders();

      await repository.deleteRider(riders.firstWhere((r) => r.firstName == 'John'));

      final remaining = await getAllRiders();
      expect(remaining.single.firstName, 'Jane');
    });

    test('does nothing if rider does not exist', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe')]);
      final riders = await getAllRiders();

      await repository.deleteRider(
        Rider(id: 9999, firstName: 'Jane', lastName: 'Roe', isActive: true, lastUpdated: DateTime.now()),
      );

      final remaining = await getAllRiders();
      expect(remaining.length, riders.length);
    });

    test('removes attendees for the given rider', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe'), rider(firstName: 'Jane', lastName: 'Doe')]);

      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      final jane = riders.firstWhere((r) => r.firstName == 'Jane');

      await rideRepository.addRides([DateTime(2026, 1, 2), DateTime(2026, 1, 3)]);

      final rides = await rideRepository.getRides();
      final ride1 = rides.first;
      final ride2 = rides.last;

      await rideRepository.updateRide(ride1, [
        RideAttendeesCompanion.insert(rideId: ride1.id, riderId: john.id),
        RideAttendeesCompanion.insert(rideId: ride1.id, riderId: jane.id),
      ]);

      await rideRepository.updateRide(ride2, [RideAttendeesCompanion.insert(rideId: ride2.id, riderId: john.id)]);

      await repository.deleteRider(john);

      final attendees = await database.select(database.rideAttendees).get();
      expect(attendees, hasLength(1));
      expect(attendees.single.riderId, jane.id);
    });

    test('removes devices for rider', () async {
      final DeviceRepository deviceRepository = DeviceRepository(database);

      await addRiders([rider(firstName: 'John', lastName: 'Doe')]);
      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');

      await Future.wait([
        deviceRepository.addDevice(DevicesCompanion.insert(name: 'Pixel', ownerId: john.id, deviceType: .phone)),
        deviceRepository.addDevice(DevicesCompanion.insert(name: 'Watch', ownerId: john.id, deviceType: .watch)),
      ]);

      await repository.deleteRider(john);

      expect(await deviceRepository.getAllDevices(), isEmpty);
    });
  });

  group('getAttendingCount', () {
    test('returns zero without attendances', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe')]);
      final john = await getAllRiders().then((riders) => riders.firstWhere((r) => r.firstName == 'John'));

      expect(await repository.getAttendingCount(john.id), 0);
    });

    test('gets the attending count per rider', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe'), rider(firstName: 'Jane', lastName: 'Roe')]);

      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      final jane = riders.firstWhere((r) => r.firstName == 'Jane');

      await rideRepository.addRides([DateTime(2026, 1, 2), DateTime(2026, 1, 3)]);

      final rides = await rideRepository.getRides();
      final rideOne = rides.first;
      final rideTwo = rides.last;

      await rideRepository.updateRide(rideOne, [
        RideAttendeesCompanion.insert(rideId: rideOne.id, riderId: john.id),
        RideAttendeesCompanion.insert(rideId: rideOne.id, riderId: jane.id),
      ]);
      await rideRepository.updateRide(rideTwo, [RideAttendeesCompanion.insert(rideId: rideTwo.id, riderId: john.id)]);

      expect(await repository.getAttendingCount(john.id), 2);
      expect(await repository.getAttendingCount(jane.id), 1);
    });
  });

  group('getRiders', () {
    test('returns an empty list for an empty table', () async {
      expect(await getAllRiders(), isEmpty);
    });

    test('returns all riders, sorted by first name, last name, then alias', () async {
      await addRiders([
        rider(firstName: 'Bob', lastName: 'Zed'),
        rider(firstName: 'Alice', lastName: 'Smith', alias: 'B', isActive: false),
        rider(firstName: 'Alice', lastName: 'Smith'),
        rider(firstName: 'Alice', lastName: 'Jones'),
      ]);

      final riders = await getAllRiders();

      expect(riders, hasLength(4));

      expect(riders[0].firstName, 'Alice');
      expect(riders[0].lastName, 'Jones');
      expect(riders[0].alias, isNull);
      expect(riders[0].isActive, isTrue);

      expect(riders[1].firstName, 'Alice');
      expect(riders[1].lastName, 'Smith');
      expect(riders[1].alias, 'B');
      expect(riders[1].isActive, isFalse);

      expect(riders[2].firstName, 'Alice');
      expect(riders[2].lastName, 'Smith');
      expect(riders[2].alias, isNull);
      expect(riders[2].isActive, isTrue);

      expect(riders[3].firstName, 'Bob');
      expect(riders[3].lastName, 'Zed');
      expect(riders[3].alias, isNull);
      expect(riders[3].isActive, isTrue);
    });

    test('filters active riders', () async {
      await addRiders([
        rider(firstName: 'Bob', lastName: 'Zed'),
        rider(firstName: 'Alice', lastName: 'Smith', alias: 'B', isActive: false),
        rider(firstName: 'Alice', lastName: 'Smith'),
        rider(firstName: 'Alice', lastName: 'Jones'),
      ]);

      final riders = await repository.getRiders(.active);

      expect(riders, hasLength(3));

      expect(riders[0].firstName, 'Alice');
      expect(riders[0].lastName, 'Jones');
      expect(riders[0].alias, isNull);
      expect(riders[0].isActive, isTrue);

      expect(riders[1].firstName, 'Alice');
      expect(riders[1].lastName, 'Smith');
      expect(riders[1].alias, isNull);
      expect(riders[1].isActive, isTrue);

      expect(riders[2].firstName, 'Bob');
      expect(riders[2].lastName, 'Zed');
      expect(riders[2].alias, isNull);
      expect(riders[2].isActive, isTrue);
    });

    test('filters inactive riders', () async {
      await addRiders([
        rider(firstName: 'Bob', lastName: 'Zed'),
        rider(firstName: 'Alice', lastName: 'Smith', alias: 'B', isActive: false),
        rider(firstName: 'Alice', lastName: 'Smith'),
        rider(firstName: 'Alice', lastName: 'Jones'),
        rider(firstName: 'Janice', lastName: 'Smith', alias: 'J', isActive: false),
      ]);

      final riders = await repository.getRiders(.inactive);

      expect(riders, hasLength(2));
      expect(riders[0].firstName, 'Alice');
      expect(riders[0].lastName, 'Smith');
      expect(riders[0].alias, 'B');
      expect(riders[0].isActive, isFalse);

      expect(riders[1].firstName, 'Janice');
      expect(riders[1].lastName, 'Smith');
      expect(riders[1].alias, 'J');
      expect(riders[1].isActive, isFalse);
    });
  });

  group('setRiderActive', () {
    test('toggles the active state for the given rider', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe')]);
      final original = (await getAllRiders()).single;

      await repository.setRiderActive(original, value: false);
      final updated = (await getAllRiders()).single;

      expect(updated.isActive, isFalse);
    });

    test('does not change the isActive state of another rider', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe'), rider(firstName: 'Jane', lastName: 'Roe')]);
      final john = (await getAllRiders()).firstWhere((r) => r.firstName == 'John');

      await repository.setRiderActive(john, value: false);

      final updatedJane = (await getAllRiders()).firstWhere((r) => r.firstName == 'Jane');
      expect(updatedJane.isActive, isTrue);
    });

    test('does nothing for a non-existent rider', () async {
      final fakeRider = Rider(
        id: 99,
        firstName: 'Fake',
        lastName: 'Rider',
        isActive: false,
        lastUpdated: DateTime.now(),
      );

      await repository.setRiderActive(fakeRider, value: false);

      expect((await getAllRiders()), isEmpty);
    });
  });

  group('updateRider', () {
    test('updates the rider and returns it', () async {
      await addRiders([
        // ignore: avoid_redundant_argument_values
        rider(firstName: 'John', lastName: 'Doe', alias: 'JD', isActive: true),
      ]);

      final riderId = (await getAllRiders()).single.id;

      final updated = await repository.updateRider(
        RidersCompanion(
          id: Value(riderId),
          firstName: const Value('Jane'),
          lastName: const Value('Roe'),
          alias: const Value('JR'),
          isActive: const Value(false),
        ),
      );

      expect(updated.id, riderId);
      expect(updated.firstName, 'Jane');
      expect(updated.lastName, 'Roe');
      expect(updated.alias, 'JR');
      expect(updated.isActive, isFalse);
      expect(await getAllRiders(), hasLength(1));
    });

    test('does not update other rider', () async {
      await addRiders([
        rider(firstName: 'John', lastName: 'Doe', alias: 'JD'),
        rider(firstName: 'Jane', lastName: 'Roe', alias: 'JR'),
      ]);

      final riders = await getAllRiders();
      final john = riders.firstWhere((r) => r.firstName == 'John');
      final jane = riders.firstWhere((r) => r.firstName == 'Jane');

      final updated = await repository.updateRider(
        RidersCompanion(
          id: Value(john.id),
          firstName: const Value('Johnny'),
          lastName: const Value('DoeN'),
          alias: const Value('JDR'),
        ),
      );

      expect(updated.id, john.id);
      expect(updated.firstName, 'Johnny');
      expect(updated.lastName, 'DoeN');
      expect(updated.alias, 'JDR');

      final allRiders = await getAllRiders();
      expect(allRiders, contains(jane));
      expect(allRiders, contains(updated));
    });

    test('updating a rider to the same values is idempotent', () async {
      await addRiders([rider(firstName: 'John', lastName: 'Doe')]);
      final john = (await getAllRiders()).single;

      final updated = await repository.updateRider(
        RidersCompanion(
          id: Value(john.id),
          firstName: const Value('John'),
          lastName: const Value('Doe'),
          alias: const Value(null),
        ),
      );

      expect(updated.firstName, 'John');
      expect(updated.lastName, 'Doe');
      expect(updated.alias, isNull);
      expect(updated.isActive, john.isActive);
      expect(updated.id, john.id);
    });

    test('throws RiderExistsException when colliding with another rider', () async {
      await addRiders([
        rider(firstName: 'John', lastName: 'Doe', alias: 'f'),
        rider(firstName: 'Jane', lastName: 'Roe'),
      ]);

      final john = (await getAllRiders()).firstWhere((r) => r.firstName == 'John');

      expect(
        () => repository.updateRider(
          RidersCompanion(
            id: Value(john.id),
            firstName: const Value('Jane'),
            lastName: const Value('Roe'),
            alias: const Value(null),
          ),
        ),
        throwsA(isA<RiderExistsException>()),
      );
    });
  });
}
