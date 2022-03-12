import 'dart:async';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/repository/ride_repository.dart';

///This class is the BLoC for the ride details page.
class RideDetailsBloc extends Bloc {
  RideDetailsBloc({
    required this.ride,
    required this.rideRepo,
    required this.memberRepo,
  });

  final MemberRepository memberRepo;
  final RideRepository rideRepo;
  Ride ride;

  Future<List<Member>>? attendeesFuture;

  void loadAttendeesIfNotLoaded() {
    attendeesFuture ??= loadRideAttendees();
  }

  Future<List<Member>> loadRideAttendees() =>
      rideRepo.getRideAttendees(ride.date);

  Future<void> deleteRide() => rideRepo.deleteRide(ride.date);

  @override
  void dispose() {}
}

enum RideDetailsPageOptions { delete, export }