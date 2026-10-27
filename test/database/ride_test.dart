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

  group('addRides', () {
    test('inserts a ride per date', () async {
      await repository.addRides([day1, day2]);

      final rides = await repository.getRides();

      expect(rides.map((r) => r.date), [day1, day2]);
      expect(await repository.getRidesCount(), 2);
      expect(await database.rideAttendees.select().get(), isEmpty);
    });

    test('inserts nothing for an empty list', () async {
      await repository.addRides([]);

      expect(await repository.getRides(), isEmpty);
      expect(await repository.getRidesCount(), 0);
      expect(await database.rideAttendees.select().get(), isEmpty);
    });

    test('stores no scanned attendees by default', () async {
      await repository.addRides([day1]);

      expect((await repository.getRides()).single.scannedAttendees, isNull);
      expect(await database.rideAttendees.select().get(), isEmpty);
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
      expect(await database.rideAttendees.select().get(), isEmpty);
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
      expect(await database.rideAttendees.select().get(), isEmpty);
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
}
