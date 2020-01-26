
import 'package:weforza/model/memberItem.dart';

///This class provides a global container for a selected [MemberItem] and a reload flag for loading [MemberItem]s from a datasource.
class MemberProvider {

  //Whether we have to reload the members or not.
  static bool reloadMembers = true;

  ///A selected [MemberItem] is stored here.
  static MemberItem selectedMember;
}