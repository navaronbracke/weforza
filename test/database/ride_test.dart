import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

void main() {
  late WeForzaDatabase database;
  late RideRepository repository;
  late RiderRepository riderRepository;

  setUp(() {
    database = WeForzaDatabase.memory();
    repository = RideRepository(database);
    riderRepository = RiderRepository(database);
  });

  tearDown(() => database.close());

  final day1 = DateTime(2026);
  final day2 = DateTime(2026, 1, 2);
  final day3 = DateTime(2026, 1, 3);

  Future<List<RideAttendee>> getAllAttendees() => database.rideAttendees.select().get();

  Future<List<Ride>> getAllRides() => repository.getRides();

  Future<List<Rider>> getAllRiders() => riderRepository.getRiders(.all);

  RideAttendeesCompanion attendeeFor(Rider rider, {required Ride ride, bool scanned = true}) {
    return RideAttendeesCompanion(riderId: Value(rider.id), rideId: Value(ride.id), isScanned: Value(scanned));
  }

  group('addRides', () {
    test('inserts a ride per date', () async {
      await repository.addRides([day1, day2]);

      final rides = await getAllRides();

      // The getRides query sorts the rides in most recent ride first.
      expect(rides.map((r) => r.date), [day2, day1]);
      expect(await getAllAttendees(), isEmpty);
    });

    test('inserts nothing for an empty list', () async {
      await repository.addRides([]);

      expect(await getAllRides(), isEmpty);
      expect(await getAllAttendees(), isEmpty);
    });

    test('stores no scanned attendees by default', () async {
      await repository.addRides([day1]);

      expect((await getAllRides()).single.scannedAttendees, isNull);
      expect(await getAllAttendees(), isEmpty);
    });
  });

  group('deleteRide', () {
    test('deletes only the given ride', () async {
      await repository.addRides([day1, day2]);
      final rides = await getAllRides();

      await repository.deleteRide(rides.firstWhere((r) => r.date == day1));

      expect((await getAllRides()).single.date, day2);
    });

    test('deletes attendees along with the ride', () async {
      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));
      final john = (await riderRepository.getRiders(.all)).single;

      await repository.addRides([day1]);
      final ride = (await getAllRides()).single;

      await repository.updateRide(ride, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride.id))]);
      await repository.deleteRide(ride);

      expect(await getAllRides(), isEmpty);
      expect(await repository.getRideAttendees(ride.date), isEmpty);
    });

    test('does not delete attendees of other ride', () async {
      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));
      final john = (await riderRepository.getRiders(.all)).single;

      await repository.addRides([day1, day2]);

      final rides = await getAllRides();
      final ride1 = rides.firstWhere((r) => r.date == day1);
      final ride2 = rides.firstWhere((r) => r.date == day2);

      await repository.updateRide(ride1, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride1.id))]);

      await repository.deleteRide(ride2);

      expect(await getAllRides(), isNotEmpty);
      expect(await repository.getRideAttendees(ride1.date), isNotEmpty);
    });
  });

  group('deleteRideCalendar', () {
    test('does nothing if there are no rides', () async {
      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));

      await repository.deleteRideCalendar();

      expect(await getAllRides(), isEmpty);
      expect(await getAllAttendees(), isEmpty);
      expect(await getAllRiders(), isNotEmpty);
    });

    test('deletes all rides and ride attendees', () async {
      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));
      final john = (await riderRepository.getRiders(.all)).single;

      await repository.addRides([day1, day2]);
      final ride = (await getAllRides()).first;

      await repository.updateRide(ride, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride.id))]);

      await repository.deleteRideCalendar();

      expect(await getAllRides(), isEmpty);
      expect(await getAllAttendees(), isEmpty);
      expect(await getAllRiders(), isNotEmpty);
    });
  });

  group('getRideById', () {
    test('returns null if the ride does not exist', () async {
      expect(await repository.getRideById(999), isNull);
    });

    test('returns selected ride', () async {
      await repository.addRides([day1, day2]);
      final ride = (await getAllRides()).firstWhere((r) => r.date == day1);

      final fetchedRide = await repository.getRideById(ride.id);
      expect(fetchedRide, isNotNull);
      expect(fetchedRide?.id, ride.id);
      expect(fetchedRide?.date, ride.date);
    });
  });

  group('getRideAttendees', () {
    test('returns an empty list for an unknown date', () async {
      expect(await repository.getRideAttendees(DateTime(1999)), isEmpty);
    });

    test('returns an empty list for a ride without attendees', () async {
      await repository.addRides([day1]);

      expect(await repository.getRideAttendees(day1), isEmpty);
    });

    test('returns the riders sorted by name', () async {
      await riderRepository.addRider(const RidersCompanion(firstName: Value('Alice'), lastName: Value('Smith')));
      await riderRepository.addRider(const RidersCompanion(firstName: Value('Bob'), lastName: Value('Zed')));
      await riderRepository.addRider(const RidersCompanion(firstName: Value('Alice'), lastName: Value('Jones')));

      final riders = await getAllRiders();

      await repository.addRides([day1]);
      final ride = (await getAllRides()).first;

      await repository.updateRide(ride, [for (final rider in riders) attendeeFor(rider, ride: ride)]);

      final attendees = await repository.getRideAttendees(day1);

      expect(attendees, hasLength(3));
      expect(attendees[0].id, riders[0].id);
      expect(attendees[0].firstName, 'Alice');
      expect(attendees[0].lastName, 'Jones');
      expect(attendees[1].id, riders[1].id);
      expect(attendees[1].firstName, 'Alice');
      expect(attendees[1].lastName, 'Smith');
      expect(attendees[2].id, riders[2].id);
      expect(attendees[2].firstName, 'Bob');
      expect(attendees[2].lastName, 'Zed');
    });
  });

  group('getRideDates', () {
    test('returns empty list if there are no rides', () async {
      expect(await repository.getRideDates(), isEmpty);
    });

    test('getRideDates returns all dates, unordered', () async {
      await repository.addRides([day2, day1, day3]);

      expect(await repository.getRideDates(), unorderedEquals([day1, day2, day3]));
    });
  });

  group('getRides', () {
    test('returns empty list if there are no rides', () async {
      expect(await repository.getRides(), isEmpty);
    });

    test('returns all rides and sorts by date descending', () async {
      await repository.addRides([day2, day1, day3]);
      final rides = await repository.getRides();

      expect(rides.map((r) => r.date), [day3, day2, day1]);
    });
  });

  group('getRidesCount', () {
    test('returns zero if there are no rides', () async {
      expect(await repository.getRidesCount(), 0);
    });

    test('getRidesCount returns the amount of rides', () async {
      await repository.addRides([day2, day1, day3]);

      expect(await repository.getRidesCount(), 3);
    });
  });

  group('getScanResults', () {
    test('returns empty list if the ride does not exist', () async {
      expect(await repository.getScanResults(DateTime(1)), isEmpty);
    });

    test('returns empty list if ride does not have attendees', () async {
      await repository.addRides([day1]);
      expect(await repository.getScanResults(day1), isEmpty);
    });

    test('only returns results for the first ride on that date', () async {
      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));
      final john = (await riderRepository.getRiders(.all)).single;

      await repository.addRides([day1, day1]);

      final rides = await getAllRides();
      final ride1 = rides.firstWhere((r) => r.date == day1);
      final ride2 = rides.lastWhere((r) => r.date == day1);

      await repository.updateRide(ride1, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride1.id))]);
      await repository.updateRide(ride2, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride2.id))]);

      final scanResults = await repository.getScanResults(day1);
      expect(scanResults, hasLength(1));
      expect(scanResults.first.id, john.id);
    });

    test('maps attendees to scan results', () async {
      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));
      await riderRepository.addRider(const RidersCompanion(firstName: Value('Jane'), lastName: Value('Doe')));
      final john = (await riderRepository.getRiders(.all)).firstWhere((r) => r.firstName == 'John');
      final jane = (await riderRepository.getRiders(.all)).firstWhere((r) => r.firstName == 'Jane');

      await repository.addRides([day1]);
      final ride = (await getAllRides()).single;

      await repository.updateRide(ride, [
        RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride.id), isScanned: const Value(false)),
        RideAttendeesCompanion(riderId: Value(jane.id), rideId: Value(ride.id), isScanned: const Value(true)),
      ]);

      final scanResults = await repository.getScanResults(ride.date);
      expect(scanResults, hasLength(2));
      expect(scanResults.firstWhere((r) => r.id == john.id).isScanned, isFalse);
      expect(scanResults.firstWhere((r) => r.id == jane.id).isScanned, isTrue);
    });
  });

  group('updateRide', () {
    late List<Rider> riders;
    late Ride ride;

    setUp(() async {
      for (final name in ['Anna', 'Ben', 'Carl']) {
        await riderRepository.addRider(RidersCompanion(firstName: Value(name), lastName: const Value('Doe')));
      }

      riders = await getAllRiders();
      await repository.addRides([day1]);
      ride = (await getAllRides()).single;
    });

    test('throws if the ride does not exist', () async {
      final missing = Ride(id: 999, date: day2);

      await expectLater(repository.updateRide(missing, [attendeeFor(riders.first, ride: ride)]), throwsStateError);
      expect(await getAllAttendees(), isEmpty);
    });

    test('throws if a rider is included twice in the attendees list', () async {
      expect(
        () =>
            repository.updateRide(ride, [attendeeFor(riders.first, ride: ride), attendeeFor(riders.first, ride: ride)]),
        throwsA(isA<Exception>()),
      );
    });

    test('throws if a rider does not exist', () async {
      final missingRider = Rider(
        id: 999,
        firstName: 'Missing',
        lastName: 'Rider',
        isActive: true,
        lastUpdated: DateTime.now(),
      );
      await expectLater(
        () => repository.updateRide(ride, [attendeeFor(missingRider, ride: ride)]),
        throwsA(isA<Exception>()),
      );
    });

    test('allows inserting the same rider into different rides', () async {
      await repository.addRides([day2]);
      final ride2 = (await getAllRides()).firstWhere((r) => r.date == day2);

      await expectLater(
        Future.wait([ride, ride2].map((ride) => repository.updateRide(ride, [attendeeFor(riders.first, ride: ride)]))),
        completes,
      );
      expect(await getAllAttendees(), hasLength(2));
    });

    test('inserts new attendees', () async {
      await repository.updateRide(ride, [attendeeFor(riders.first, ride: ride), attendeeFor(riders.last, ride: ride)]);

      final attendees = await getAllAttendees();

      expect(attendees, hasLength(2));
      expect(attendees.first.riderId, riders.first.id);
      expect(attendees.first.rideId, ride.id);
      expect(attendees.first.isScanned, isTrue);
      expect(attendees.last.riderId, riders.last.id);
      expect(attendees.last.rideId, ride.id);
      expect(attendees.last.isScanned, isTrue);

      final updatedRide = await repository.getRideById(ride.id);

      expect(updatedRide, isNotNull);
      expect(updatedRide?.scannedAttendees, 2);
    });

    test('inserts new attendees with isScanned set to true as default', () async {
      await repository.updateRide(ride, [
        RideAttendeesCompanion(riderId: Value(riders.first.id), rideId: Value(ride.id)),
      ]);

      final attendees = await getAllAttendees();
      expect(attendees, hasLength(1));
      expect(attendees.first.riderId, riders.first.id);
      expect(attendees.first.rideId, ride.id);
      expect(attendees.first.isScanned, isTrue);
    });

    test('removes attendees that are no longer present', () async {
      await repository.updateRide(ride, riders.map((r) => attendeeFor(r, ride: ride)).toList());

      final attendeesBefore = await getAllAttendees();

      await repository.updateRide(ride, [attendeeFor(riders.first, ride: ride)]);

      final attendeeAfter = await getAllAttendees();
      expect(attendeeAfter, hasLength(1));
      expect(attendeeAfter.first.id, attendeesBefore.first.id);
      expect(attendeeAfter.first.riderId, riders.first.id);
      expect(attendeeAfter.first.rideId, ride.id);
      expect(attendeeAfter.first.isScanned, isTrue);

      final updatedRide = await repository.getRideById(ride.id);

      expect(updatedRide, isNotNull);
      expect(updatedRide?.scannedAttendees, 1);
    });

    test('removes all attendees with an empty list', () async {
      await repository.updateRide(ride, riders.map((r) => attendeeFor(r, ride: ride)).toList());
      await repository.updateRide(ride, []);

      final attendees = await getAllAttendees();
      expect(attendees.where((a) => a.rideId == ride.id), isEmpty);
    });

    test('updates the state for existing attendees instead of replacing them', () async {
      await repository.updateRide(ride, riders.map((r) => attendeeFor(r, ride: ride)).toList());

      final attendeesBefore = await getAllAttendees();

      await repository.updateRide(ride, riders.map((r) => attendeeFor(r, ride: ride, scanned: false)).toList());

      final attendeesAfter = await getAllAttendees();

      expect(attendeesAfter.length, attendeesBefore.length);

      for (var i = 0; i < attendeesBefore.length; i++) {
        expect(attendeesAfter[i].id, attendeesBefore[i].id);
        expect(attendeesAfter[i].riderId, attendeesBefore[i].riderId);
        expect(attendeesAfter[i].rideId, attendeesBefore[i].rideId);
        expect(attendeesAfter[i].isScanned, isFalse);
      }

      final updatedRide = await repository.getRideById(ride.id);

      expect(updatedRide, isNotNull);
      expect(updatedRide?.scannedAttendees, 0);
    });

    test('does not update the attendees of a different ride', () async {
      // Day 1 is already present via the test setup.
      await repository.addRides([day2]);

      final ride2 = (await getAllRides()).firstWhere((r) => r.date == day2);

      await repository.updateRide(ride, [attendeeFor(riders[0], ride: ride)]);
      await repository.updateRide(ride2, [attendeeFor(riders[1], ride: ride2), attendeeFor(riders[2], ride: ride2)]);

      await repository.updateRide(ride, [attendeeFor(riders[1], ride: ride)]);

      final attendees = await getAllAttendees();
      expect(attendees.where((a) => a.rideId == ride.id).map((a) => a.riderId), [riders[1].id]);
      expect(
        attendees.where((a) => a.rideId == ride2.id).map((a) => a.riderId),
        unorderedEquals([riders[1].id, riders[2].id]),
      );
    });
  });

  test('watchRidesCount emits changes to the number of rides', () async {
    final expectation = expectLater(repository.watchRidesCount(), emitsInOrder([0, 3, 4, 3, 0]));

    await repository.addRides([]);
    await Future<void>.delayed(.zero);

    await repository.addRides([day2, day1, day3]);
    await Future<void>.delayed(.zero);

    await repository.addRides([DateTime(2026, 1, 4)]);
    await Future<void>.delayed(.zero);

    final Ride ride = await getAllRides().then((rides) => rides.first);

    await repository.deleteRide(ride);
    await Future<void>.delayed(.zero);

    await repository.deleteRideCalendar();
    await Future<void>.delayed(.zero);

    await expectation;
  });
}
