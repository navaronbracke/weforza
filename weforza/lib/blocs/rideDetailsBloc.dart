
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/attendee.dart';
import 'package:weforza/model/attendeeItem.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class is the BLoC for the ride details page.
class RideDetailsBloc extends Bloc {
  RideDetailsBloc(this._memberRepository,this._rideRepository): assert(_memberRepository != null && _rideRepository != null);

  final MemberRepository _memberRepository;
  final RideRepository _rideRepository;

  Future<List<AttendeeItem>> loadRideAttendees(DateTime date) async {
    List<Attendee> attendees = await _memberRepository.getRideAttendees(date);
    List<Future<AttendeeItem>> items = attendees.map((attendee) async =>
        AttendeeItem(attendee.uuid,attendee.firstname,attendee.lastname,await _memberRepository.loadProfileImageFromDisk(attendee.image))).toList();
    return Future.wait(items);
  }

  Future<void> deleteRide(DateTime date) => _rideRepository.deleteRide(date);

  @override
  void dispose() {}

}