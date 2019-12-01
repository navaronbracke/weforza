
import 'dart:io';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/pages/rideList/rideListSelector.dart';

///This class is the BLoC for RideListMemberItem.
class RideListAttendeeItemBloc extends Bloc implements IRideAttendeeSelectable {
  RideListAttendeeItemBloc(this._member,this.image,this.isSelected): assert(_member != null && isSelected != null);

  File image;

  bool isSelected;

  final Member _member;

  String get firstName => _member.firstname;

  String get lastName => _member.lastname;

  @override
  void dispose() {}

  @override
  Attendee getAttendee() => Attendee(firstName,lastName,_member.phone);

  @override
  void select() => isSelected = true;

  @override
  void unSelect() => isSelected = false;

}