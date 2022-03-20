import 'package:weforza/model/member_filter_option.dart';

/// This class represents a delegate for managing the member list filter option
/// in the settings page.
abstract class MemberListFilterDelegate {
  /// Get the current value.
  MemberFilterOption get memberListFilter;

  /// Update the value.
  void onMemberListFilterChanged(MemberFilterOption newValue);
}
