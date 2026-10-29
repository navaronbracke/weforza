import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/export/exportable_ride.dart';
import 'package:weforza/model/export/exportable_ride_attendee.dart';
import 'package:weforza/model/export/exportable_ride_with_attendees.dart';
import 'package:weforza/repository/export_rides_repository.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

void main() {
  late WeForzaDatabase database;
  late ExportRidesRepository exportRidesRepository;
  late RideRepository rideRepository;
  late RiderRepository riderRepository;
  late Rider alex;
  late Rider janeD;
  late Rider janeR;
  late Rider john;
  late Rider jimJB;
  late Rider jimJ;
  late Rider jim;

  setUp(() async {
    database = WeForzaDatabase.memory();
    exportRidesRepository = ExportRidesRepository(database);
    rideRepository = RideRepository(database);
    riderRepository = RiderRepository(database);

    await Future.wait([
      riderRepository.addRider(.insert(firstName: 'Alex', lastName: 'Jones')),
      riderRepository.addRider(.insert(firstName: 'Jane', lastName: 'Doe')),
      riderRepository.addRider(.insert(firstName: 'Jane', lastName: 'Roe')),
      riderRepository.addRider(.insert(firstName: 'John', lastName: 'Doe')),
      riderRepository.addRider(.insert(firstName: 'Jim', lastName: 'Beam', alias: const Value('JB'))),
      riderRepository.addRider(.insert(firstName: 'Jim', lastName: 'Beam', alias: const Value('J'))),
      riderRepository.addRider(.insert(firstName: 'Jim', lastName: 'Beam')),
    ]);

    final riders = await riderRepository.getRiders(.all);
    alex = riders.firstWhere((r) => r.firstName == 'Alex' && r.lastName == 'Jones');
    janeD = riders.firstWhere((r) => r.firstName == 'Jane' && r.lastName == 'Doe');
    janeR = riders.firstWhere((r) => r.firstName == 'Jane' && r.lastName == 'Roe');
    john = riders.firstWhere((r) => r.firstName == 'John' && r.lastName == 'Doe');
    jimJB = riders.firstWhere((r) => r.firstName == 'Jim' && r.lastName == 'Beam' && r.alias == 'JB');
    jimJ = riders.firstWhere((r) => r.firstName == 'Jim' && r.lastName == 'Beam' && r.alias == 'J');
    jim = riders.firstWhere((r) => r.firstName == 'Jim' && r.lastName == 'Beam' && r.alias == null);
  });

  tearDown(() => database.close());

  group('getRides without a given date', () {
    test('returns an empty list when there are no rides', () async {
      expect(await exportRidesRepository.getRides(null), isEmpty);
    });

    test('returns rides without attendees sorted descending on date', () async {
      await rideRepository.addRides([DateTime(2024, 1, 5), DateTime(2024, 1, 12)]);

      final rides = await exportRidesRepository.getRides(null);

      expect(rides, [
        ExportableRideWithAttendees(
          ride: ExportableRide(date: DateTime(2024, 1, 12)),
          attendees: [],
        ),
        ExportableRideWithAttendees(
          ride: ExportableRide(date: DateTime(2024, 1, 5)),
          attendees: [],
        ),
      ]);
    });

    test('returns rides with attendees descending on date', () async {
      await rideRepository.addRides([DateTime(2024, 1, 5), DateTime(2024, 1, 12)]);

      final [newerRide, olderRide] = await rideRepository.getRides();

      await rideRepository.updateRide(olderRide, [.insert(riderId: john.id, rideId: olderRide.id)]);

      await rideRepository.updateRide(newerRide, [.insert(riderId: alex.id, rideId: newerRide.id)]);

      final exported = await exportRidesRepository.getRides(null);

      expect(exported, [
        ExportableRideWithAttendees(
          ride: ExportableRide(date: DateTime(2024, 1, 12)),
          attendees: [ExportableRideAttendee(firstName: 'Alex', lastName: 'Jones')],
        ),
        ExportableRideWithAttendees(
          ride: ExportableRide(date: DateTime(2024, 1, 5)),
          attendees: [ExportableRideAttendee(firstName: 'John', lastName: 'Doe')],
        ),
      ]);
    });

    test('returns rides with attendees, attendees sorted by first name, last name and alias', () async {
      await rideRepository.addRides([DateTime(2024, 1, 12)]);
      final [ride1] = await rideRepository.getRides();

      await rideRepository.updateRide(ride1, [
        .insert(riderId: john.id, rideId: ride1.id),
        .insert(riderId: alex.id, rideId: ride1.id),
        .insert(riderId: jim.id, rideId: ride1.id),
        .insert(riderId: jimJB.id, rideId: ride1.id),
        .insert(riderId: jimJ.id, rideId: ride1.id),
        .insert(riderId: janeR.id, rideId: ride1.id),
        .insert(riderId: janeD.id, rideId: ride1.id),
      ]);

      final exported = await exportRidesRepository.getRides(null);
      expect(exported, [
        ExportableRideWithAttendees(
          ride: ExportableRide(date: DateTime(2024, 1, 12)),
          attendees: [
            ExportableRideAttendee(firstName: 'Alex', lastName: 'Jones'),
            ExportableRideAttendee(firstName: 'Jane', lastName: 'Doe'),
            ExportableRideAttendee(firstName: 'Jane', lastName: 'Roe'),
            ExportableRideAttendee(firstName: 'Jim', lastName: 'Beam', alias: 'J'),
            ExportableRideAttendee(firstName: 'Jim', lastName: 'Beam', alias: 'JB'),
            ExportableRideAttendee(firstName: 'Jim', lastName: 'Beam'),
            ExportableRideAttendee(firstName: 'John', lastName: 'Doe'),
          ],
        ),
      ]);
    });

    test('does not include riders that did not attend', () async {
      await rideRepository.addRides([DateTime(2024, 1, 12)]);
      final [ride1] = await rideRepository.getRides();

      await rideRepository.updateRide(ride1, [.insert(riderId: john.id, rideId: ride1.id)]);

      final exported = await exportRidesRepository.getRides(null);
      expect(exported.first.attendees, isNot(contains(ExportableRideAttendee(firstName: 'Jim', lastName: 'Beam'))));
    });
  });

  group('getRides with a given date', () {
    final date = DateTime(2024, 1, 12);

    test('returns empty list if there is no ride on the date', () async {
      expect(await exportRidesRepository.getRides(date), isEmpty);
    });

    test('returns only the ride for the given date', () async {
      await rideRepository.addRides([date, DateTime(2024, 1, 13)]);

      final exported = await exportRidesRepository.getRides(date);
      expect(exported, hasLength(1));
      expect(exported.single.ride.date, date);
    });

    test('returns ride with attendees sorted by first name, last name and alias', () async {
      await rideRepository.addRides([date]);
      final [ride] = await rideRepository.getRides();

      await rideRepository.updateRide(ride, [
        .insert(riderId: john.id, rideId: ride.id),
        .insert(riderId: alex.id, rideId: ride.id),
        .insert(riderId: jim.id, rideId: ride.id),
        .insert(riderId: jimJB.id, rideId: ride.id),
        .insert(riderId: jimJ.id, rideId: ride.id),
        .insert(riderId: janeR.id, rideId: ride.id),
        .insert(riderId: janeD.id, rideId: ride.id),
      ]);

      final exported = await exportRidesRepository.getRides(null);
      expect(exported, [
        ExportableRideWithAttendees(
          ride: ExportableRide(date: DateTime(2024, 1, 12)),
          attendees: [
            ExportableRideAttendee(firstName: 'Alex', lastName: 'Jones'),
            ExportableRideAttendee(firstName: 'Jane', lastName: 'Doe'),
            ExportableRideAttendee(firstName: 'Jane', lastName: 'Roe'),
            ExportableRideAttendee(firstName: 'Jim', lastName: 'Beam', alias: 'J'),
            ExportableRideAttendee(firstName: 'Jim', lastName: 'Beam', alias: 'JB'),
            ExportableRideAttendee(firstName: 'Jim', lastName: 'Beam'),
            ExportableRideAttendee(firstName: 'John', lastName: 'Doe'),
          ],
        ),
      ]);
    });

    test('does not include riders that did not attend', () async {
      await rideRepository.addRides([date]);
      final [ride] = await rideRepository.getRides();

      await rideRepository.updateRide(ride, [
        .insert(riderId: john.id, rideId: ride.id),
        .insert(riderId: alex.id, rideId: ride.id),
      ]);

      final exported = await exportRidesRepository.getRides(null);
      expect(exported.single.attendees, [
        ExportableRideAttendee(firstName: 'Alex', lastName: 'Jones'),
        ExportableRideAttendee(firstName: 'John', lastName: 'Doe'),
      ]);
    });
  });
}
