
import 'package:weforza/model/memberItem.dart';

///This class provides a global container for a selected [MemberItem] and a reload flag for loading [MemberItem]s from a datasource.
class MemberProvider {
  ///This flag guards the load of [MemberItem].
  ///A load can only happen if this flag got set to true with its setter.
  ///Upon calling its getter, it gets reset.
  ///We start the flag on true, since we want the initial data to load without the setter having been called.
  static bool _shouldReloadMembers = true;

  ///Get the member reload flag's value.
  ///Calling this getter resets the value to false.
  static bool get reloadMembers {
    bool oldValue = _shouldReloadMembers;
    _shouldReloadMembers = false;
    return oldValue;
  }

  ///Set [_shouldReloadMembers] to a new value.
  static set reloadMembers(bool value){
    _shouldReloadMembers = value;
  }

  ///A selected [MemberItem] is stored here.
  static MemberItem selectedMember;
}