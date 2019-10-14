
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';

///This is the BLoC for RideListPage.
class RideListBloc extends Bloc {
  RideListBloc(this._memberRepository,this._rideRepository): assert(_rideRepository != null && _memberRepository != null);

  final IRideRepository _rideRepository;
  final IMemberRepository _memberRepository;

  ///Show only the attending people.
  bool showAttendingOnly = false;

  ///The amount of people that are attending a [Ride].
  String attendingCount = "---";

  ///Get all rides.
  Future<List<Ride>> getAllRides() => _rideRepository.getAllRides();
  ///Get all members.
  Future<List<Member>> getAllMembers() => _memberRepository.getAllMembers();


  @override
  void dispose() {}


}