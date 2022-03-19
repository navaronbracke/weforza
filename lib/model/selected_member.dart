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

  @override
  int get hashCode => Object.hash(attendingCount, profileImage, value);

  @override
  bool operator ==(Object other) {
    return other is SelectedMember &&
        attendingCount == other.attendingCount &&
        profileImage == other.profileImage &&
        value == other.value;
  }
}