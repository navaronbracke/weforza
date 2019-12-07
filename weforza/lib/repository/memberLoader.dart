
import 'package:weforza/model/member.dart';

abstract class MemberLoader {
  Future<List<Member>> get memberFuture;

  set memberFuture(Future<List<Member>> future);
}