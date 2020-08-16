
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class is the BLoC for the ride details page.
class RideDetailsBloc extends Bloc {
  RideDetailsBloc({
    @required this.ride,
    @required this.rideRepo,
    @required this.memberRepo
  }): assert(ride != null && memberRepo != null && rideRepo != null);

  final MemberRepository memberRepo;
  final RideRepository rideRepo;
  Ride ride;

  Future<List<MemberItem>> attendeesFuture;

  void loadAttendeesIfNotLoaded(){
    if(attendeesFuture == null){
      attendeesFuture = loadRideAttendees();
    }
  }

  Future<List<MemberItem>> loadRideAttendees() async {
    List<Member> attendees = await rideRepo.getRideAttendees(ride.date);
    List<Future<MemberItem>> items = attendees.map((attendee) async =>
        MemberItem(attendee,await memberRepo.loadProfileImageFromDisk(attendee.profileImageFilePath))).toList();
    final list = await Future.wait(items);
    return list;
  }

  Future<void> deleteRide() => rideRepo.deleteRide(ride.date);

  @override
  void dispose() {}

}

enum RideDetailsPageOptions {
  EDIT,
  DELETE,
  EXPORT
}