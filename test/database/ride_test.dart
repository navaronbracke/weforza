import 'package:drift/drift.dart' hide isNull;
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
}
