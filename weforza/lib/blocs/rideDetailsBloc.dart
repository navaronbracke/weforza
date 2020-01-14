
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/attendee.dart';
import 'package:weforza/model/attendeeItem.dart';
import 'package:weforza/repository/memberRepository.dart';

///This class is the BLoC for the ride details page.
class RideDetailsBloc extends Bloc {
  RideDetailsBloc(this._repository): assert(_repository != null);

  final MemberRepository _repository;

  Future<List<AttendeeItem>> getRideAttendees(DateTime date) async {
    List<Attendee> attendees = await _repository.getRideAttendees(date);
    List<Future<AttendeeItem>> items = attendees.map((attendee) async =>
        AttendeeItem(attendee.uuid,attendee.firstname,attendee.lastname,await _repository.loadProfileImageFromDisk(attendee.image))).toList();
    return Future.wait(items);
  }

  @override
  void dispose() {}

}