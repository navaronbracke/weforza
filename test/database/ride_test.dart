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
}
