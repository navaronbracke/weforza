
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

///This class is the BLoC for the ride details page.
class RideDetailsBloc extends Bloc {
  RideDetailsBloc(this._memberRepository,this._rideRepository): assert(_memberRepository != null && _rideRepository != null);

  final MemberRepository _memberRepository;
  final RideRepository _rideRepository;

  Future<List<MemberItem>> loadRideAttendees(DateTime date) async {
    List<Member> attendees = await _memberRepository.getRideAttendees(date);
    List<Future<MemberItem>> items = attendees.map((attendee) async =>
        MemberItem(attendee,await _memberRepository.loadProfileImageFromDisk(attendee.profileImageFilePath))).toList();
    return Future.wait(items);
  }

  Future<void> deleteRide(DateTime date) => _rideRepository.deleteRide(date);

  @override
  void dispose() {}

}