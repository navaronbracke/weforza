import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

void main() {
  late WeForzaDatabase database;
  late RideRepository repository;

  setUp(() {
    database = WeForzaDatabase.memory();
    repository = RideRepository(database);
  });

  tearDown(() => database.close());

  final day1 = DateTime(2026);
  final day2 = DateTime(2026, 1, 2);
  final day3 = DateTime(2026, 1, 3);

  Future<List<RideAttendee>> allAttendees() => database.rideAttendees.select().get();

  group('addRides', () {
    test('inserts a ride per date', () async {
      await repository.addRides([day1, day2]);

      final rides = await repository.getRides();

      expect(rides.map((r) => r.date), [day1, day2]);
      expect(await repository.getRidesCount(), 2);
      expect(await allAttendees(), isEmpty);
    });

    test('inserts nothing for an empty list', () async {
      await repository.addRides([]);

      expect(await repository.getRides(), isEmpty);
      expect(await repository.getRidesCount(), 0);
      expect(await allAttendees(), isEmpty);
    });

    test('stores no scanned attendees by default', () async {
      await repository.addRides([day1]);

      expect((await repository.getRides()).single.scannedAttendees, isNull);
      expect(await allAttendees(), isEmpty);
    });
  });

  group('deleteRide', () {
    test('deletes only the given ride', () async {
      await repository.addRides([day1, day2]);
      final rides = await repository.getRides();

      await repository.deleteRide(rides.firstWhere((r) => r.date == day1));

      expect((await repository.getRides()).single.date, day2);
    });

    test('deletes attendees along with the ride', () async {
      final RiderRepository riderRepository = RiderRepository(database);

      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));
      final john = (await riderRepository.getRiders(.all)).single;

      await repository.addRides([day1]);
      final ride = (await repository.getRides()).single;

      await repository.updateRide(ride, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride.id))]);
      await repository.deleteRide(ride);

      expect(await repository.getRides(), isEmpty);
      expect(await repository.getRideAttendees(ride.date), isEmpty);
    });

    test('does not delete attendees of other ride', () async {
      final RiderRepository riderRepository = RiderRepository(database);

      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));
      final john = (await riderRepository.getRiders(.all)).single;

      await repository.addRides([day1, day2]);

      final rides = await repository.getRides();
      final ride1 = rides.firstWhere((r) => r.date == day1);
      final ride2 = rides.firstWhere((r) => r.date == day2);

      await repository.updateRide(ride1, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride1.id))]);

      await repository.deleteRide(ride2);

      expect(await repository.getRides(), isNotEmpty);
      expect(await repository.getRideAttendees(ride1.date), isNotEmpty);
    });
  });

  group('deleteRideCalendar', () {
    test('does nothing if there are no rides', () async {
      final RiderRepository riderRepository = RiderRepository(database);

      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));

      await repository.deleteRideCalendar();

      expect(await repository.getRides(), isEmpty);
      expect(await allAttendees(), isEmpty);
      expect(await riderRepository.getRiders(.all), isNotEmpty);
    });

    test('deletes all rides and ride attendees', () async {
      final RiderRepository riderRepository = RiderRepository(database);

      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));
      final john = (await riderRepository.getRiders(.all)).single;

      await repository.addRides([day1, day2]);
      final ride = (await repository.getRides()).first;

      await repository.updateRide(ride, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride.id))]);

      await repository.deleteRideCalendar();

      expect(await repository.getRidesCount(), 0);
      expect(await allAttendees(), isEmpty);
      expect(await riderRepository.getRiders(.all), isNotEmpty);
    });
  });

  group('getRideById', () {
    test('returns null if the ride does not exist', () async {
      expect(await repository.getRideById(999), isNull);
    });

    test('returns selected ride', () async {
      await repository.addRides([day1, day2]);
      final ride = (await repository.getRides()).firstWhere((r) => r.date == day1);

      final fetchedRide = await repository.getRideById(ride.id);
      expect(fetchedRide, isNotNull);
      expect(fetchedRide?.id, ride.id);
      expect(fetchedRide?.date, ride.date);
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
      final RiderRepository riderRepository = RiderRepository(database);

      await riderRepository.addRider(const RidersCompanion(firstName: Value('John'), lastName: Value('Doe')));
      final john = (await riderRepository.getRiders(.all)).single;

      await repository.addRides([day1, day1]);

      final ride1 = (await repository.getRides()).firstWhere((r) => r.date == day1);
      final ride2 = (await repository.getRides()).lastWhere((r) => r.date == day1);

      await repository.updateRide(ride1, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride1.id))]);
      await repository.updateRide(ride2, [RideAttendeesCompanion(riderId: Value(john.id), rideId: Value(ride2.id))]);

      final scanResults = await repository.getScanResults(day1);
      expect(scanResults, hasLength(1));
      expect(scanResults.first.id, john.id);
    });
  });

  group('updateRide', () {
    late RiderRepository riderRepository;
    late List<Rider> riders;
    late Ride ride;

    RideAttendeesCompanion attendeeFor(Rider rider, {bool scanned = true}) =>
        RideAttendeesCompanion(riderId: Value(rider.id), rideId: Value(ride.id), isScanned: Value(scanned));

    setUp(() async {
      riderRepository = RiderRepository(database);

      for (final name in ['Anna', 'Ben', 'Carl']) {
        await riderRepository.addRider(RidersCompanion(firstName: Value(name), lastName: const Value('Doe')));
      }

      riders = await riderRepository.getRiders(.all);
      await repository.addRides([day1]);
      ride = (await repository.getRides()).single;
    });

    test('throws if the ride does not exist', () async {
      final missing = Ride(id: ride.id + 999, date: day2);

      await expectLater(repository.updateRide(missing, [attendeeFor(riders.first)]), throwsStateError);
      expect(await allAttendees(), isEmpty);
    });

    test('inserts new attendees', () async {
      await repository.updateRide(ride, [attendeeFor(riders.first), attendeeFor(riders.last)]);

      final attendees = await allAttendees();

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

    test('removes attendees that are no longer present', () async {
      await repository.updateRide(ride, riders.map(attendeeFor).toList());

      final attendeesBefore = await allAttendees();

      await repository.updateRide(ride, [attendeeFor(riders.first)]);

      final attendeeAfter = await allAttendees();
      expect(attendeeAfter, hasLength(1));
      expect(attendeeAfter.first.id, attendeesBefore.first.id);
      expect(attendeeAfter.first.riderId, riders.first.id);
      expect(attendeeAfter.first.rideId, ride.id);
      expect(attendeeAfter.first.isScanned, isTrue);

      final updatedRide = await repository.getRideById(ride.id);

      expect(updatedRide, isNotNull);
      expect(updatedRide?.scannedAttendees, 1);
    });

    test('updates the state for existing attendees instead of replacing them', () async {
      await repository.updateRide(ride, riders.map(attendeeFor).toList());

      final attendeesBefore = await allAttendees();

      await repository.updateRide(ride, riders.map((r) => attendeeFor(r, scanned: false)).toList());

      final attendeesAfter = await allAttendees();

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
  });

  test('watchRidesCount emits changes to the number of rides', () async {
    final expectation = expectLater(repository.watchRidesCount(), emitsInOrder([0, 3, 4, 3, 0]));

    await repository.addRides([]);
    await Future<void>.delayed(.zero);

    await repository.addRides([day2, day1, day3]);
    await Future<void>.delayed(.zero);

    await repository.addRides([DateTime(2026, 1, 4)]);
    await Future<void>.delayed(.zero);

    final Ride ride = await repository.getRides().then((rides) => rides.first);

    await repository.deleteRide(ride);
    await Future<void>.delayed(.zero);

    await repository.deleteRideCalendar();
    await Future<void>.delayed(.zero);

    await expectation;
  });
}
