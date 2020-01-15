
import 'dart:io';

import 'package:weforza/model/member.dart';

///This class wraps a [Member] and its loaded profile image.
class MemberItem {
  MemberItem(this._member,this.profileImage): assert(_member != null);

  final Member _member;
  final File profileImage;

  String get firstName => _member.firstname;
  String get lastName => _member.lastname;
  String get uuid => _member.uuid;
  String get phone => _member.phone;
  List<String> get devices => _member.devices;
}