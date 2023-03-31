
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberFilterOption.dart';

/// This class wraps a list of [Member]s
/// and the currently active [MemberFilterOption].
class MembersListWithFilterModel {
  MembersListWithFilterModel({
    required this.items,
    required this.filter,
  });

  final List<Member> items;
  final MemberFilterOption filter;
}