import 'dart:io';

import 'package:weforza/model/member.dart';

/// This class represents the selected member.
class SelectedMember {
  const SelectedMember(this.attendingCount, this.profileImage, this.value);

  /// The attending count of [value].
  final Future<int> attendingCount;

  /// The profile image of [value].
  final Future<File?> profileImage;

  /// The member that was selected.
  final Member value;
}
