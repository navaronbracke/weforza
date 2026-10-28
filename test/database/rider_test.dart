import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

void main() {
  late WeForzaDatabase database;
  late RiderRepository repository;

  setUp(() {
    database = WeForzaDatabase.memory();
    repository = RiderRepository(database);
  });

  tearDown(() => database.close());

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
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));

      final riders = await repository.getRiders(.all);

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

      await repository.addRider(rider(firstName: 'A', lastName: 'B', profileImageUri: uri));

      expect((await repository.getRiders(.all)).single.profileImageUri, uri);
    });

    test('throws RiderExistsException for a duplicate rider', () async {
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe', alias: 'JD'));

      expect(
        () => repository.addRider(rider(firstName: 'John', lastName: 'Doe', alias: 'JD')),
        throwsA(isA<RiderExistsException>()),
      );
    });

    test('allows the same name with a different alias', () async {
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe', alias: 'JD'));
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));

      final riders = await repository.getRiders(.all);

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
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));
      await repository.addRider(rider(firstName: 'Jane', lastName: 'Roe'));
      final riders = await repository.getRiders(.all);

      await repository.deleteRider(riders.firstWhere((r) => r.firstName == 'John'));

      final remaining = await repository.getRiders(.all);
      expect(remaining.single.firstName, 'Jane');
    });

    test('does nothing if rider does not exist', () async {
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));
      final riders = await repository.getRiders(.all);

      await repository.deleteRider(
        Rider(id: 9999, firstName: 'Jane', lastName: 'Roe', isActive: true, lastUpdated: DateTime.now()),
      );

      final remaining = await repository.getRiders(.all);
      expect(remaining.length, riders.length);
    });

    test('removes attendees for the given rider', () async {
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));
      await repository.addRider(rider(firstName: 'Jane', lastName: 'Doe'));

      final john = await repository.getRiders(.all).then((riders) => riders.firstWhere((r) => r.firstName == 'John'));
      final jane = await repository.getRiders(.all).then((riders) => riders.firstWhere((r) => r.firstName == 'Jane'));

      final rideRepository = RideRepository(database);

      await rideRepository.addRides([DateTime(2026, 1, 2), DateTime(2026, 1, 3)]);

      final rides = await rideRepository.getRides();

      await database.batch((batch) {
        batch.insertAll(database.rideAttendees, [
          RideAttendeesCompanion.insert(rideId: rides.first.id, riderId: john.id),
          RideAttendeesCompanion.insert(rideId: rides.first.id, riderId: jane.id),
          RideAttendeesCompanion.insert(rideId: rides.last.id, riderId: john.id),
        ]);
      });

      await (database.delete(database.riders)..where((t) => t.id.equals(john.id))).go();

      final attendees = await database.select(database.rideAttendees).get();
      expect(attendees, hasLength(1));
      expect(attendees.single.riderId, jane.id);
    });
  });

  group('getAttendingCount', () {
    test('returns zero without attendances', () async {
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));
      final john = await repository.getRiders(.all).then((riders) => riders.firstWhere((r) => r.firstName == 'John'));

      expect(await repository.getAttendingCount(john.id), 0);
    });

    test('gets the attending count per rider', () async {
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));
      await repository.addRider(rider(firstName: 'Jane', lastName: 'Roe'));

      final john = await repository.getRiders(.all).then((riders) => riders.firstWhere((r) => r.firstName == 'John'));
      final jane = await repository.getRiders(.all).then((riders) => riders.firstWhere((r) => r.firstName == 'Jane'));

      await database.batch((batch) {
        batch.insertAll(database.rides, [
          RidesCompanion.insert(date: DateTime(2026, 1, 3)),
          RidesCompanion.insert(date: DateTime(2026, 1, 2)),
        ]);
      });

      final rides = await database.select(database.rides).get();
      final rideOne = rides.first;
      final rideTwo = rides.last;

      await database.batch((batch) {
        batch.insertAll(database.rideAttendees, [
          RideAttendeesCompanion.insert(rideId: rideOne.id, riderId: john.id),
          RideAttendeesCompanion.insert(rideId: rideTwo.id, riderId: john.id),
          RideAttendeesCompanion.insert(rideId: rideOne.id, riderId: jane.id),
        ]);
      });

      expect(await repository.getAttendingCount(john.id), 2);
      expect(await repository.getAttendingCount(jane.id), 1);
    });
  });

  group('getRiders', () {
    Future<void> addTestRiders() async {
      await repository.addRider(rider(firstName: 'Bob', lastName: 'Zed'));
      await repository.addRider(rider(firstName: 'Alice', lastName: 'Smith', alias: 'B', isActive: false));
      await repository.addRider(rider(firstName: 'Alice', lastName: 'Smith'));
      await repository.addRider(rider(firstName: 'Alice', lastName: 'Jones'));
    }

    test('returns an empty list for an empty table', () async {
      expect(await repository.getRiders(.all), isEmpty);
    });

    test('returns all riders, sorted by first name, last name, then alias', () async {
      await addTestRiders();

      final riders = await repository.getRiders(.all);

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
      await addTestRiders();

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
      await repository.addRider(rider(firstName: 'Bob', lastName: 'Zed'));
      await repository.addRider(rider(firstName: 'Alice', lastName: 'Smith', alias: 'B', isActive: false));
      await repository.addRider(rider(firstName: 'Alice', lastName: 'Smith'));
      await repository.addRider(rider(firstName: 'Alice', lastName: 'Jones'));
      await repository.addRider(rider(firstName: 'Janice', lastName: 'Smith', alias: 'J', isActive: false));

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
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));
      final original = (await repository.getRiders(.all)).single;

      await repository.setRiderActive(original, value: false);

      final updated = (await repository.getRiders(.all)).single;

      expect(updated.isActive, isFalse);
    });

    test('does not change the isActive state of another rider', () async {
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));
      await repository.addRider(rider(firstName: 'Jane', lastName: 'Roe'));
      final john = (await repository.getRiders(.all)).firstWhere((r) => r.firstName == 'John');

      await repository.setRiderActive(john, value: false);

      final updatedJane = (await repository.getRiders(.all)).firstWhere((r) => r.firstName == 'Jane');
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

      expect((await repository.getRiders(.all)), isEmpty);
    });
  });

  group('updateRider', () {
    test('updates the rider and returns it', () async {
      await repository.addRider(
        // ignore: avoid_redundant_argument_values
        rider(firstName: 'John', lastName: 'Doe', alias: 'JD', isActive: true),
      );

      final riderId = (await repository.getRiders(.all)).single.id;

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
      expect(await repository.getRiders(.all), hasLength(1));
    });

    test('does not update other rider', () async {
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe', alias: 'JD'));
      await repository.addRider(rider(firstName: 'Jane', lastName: 'Roe', alias: 'JR'));

      final riders = await repository.getRiders(.all);
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

      final allRiders = await repository.getRiders(.all);
      expect(allRiders, contains(jane));
      expect(allRiders, contains(updated));
    });

    test('updating a rider to the same values is idempotent', () async {
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe'));
      final john = (await repository.getRiders(.all)).single;

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
      await repository.addRider(rider(firstName: 'John', lastName: 'Doe', alias: 'f'));
      await repository.addRider(rider(firstName: 'Jane', lastName: 'Roe'));

      final john = (await repository.getRiders(.all)).firstWhere((r) => r.firstName == 'John');

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
