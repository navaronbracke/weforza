import 'dart:io';

/// This class represents the model to add or edit a member.
class MemberPayload {
  /// The default constructor.
  const MemberPayload({
    this.activeMember = true,
    required this.alias,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.uuid,
  });

  /// Whether this member is an active member.
  final bool activeMember;

  /// The alias for the member.
  final String alias;

  /// The first name for the member.
  final String firstName;

  /// The last name for the member.
  final String lastName;

  /// The file that represents the member's profile image.
  final Future<File?> profileImage;

  /// The uuid of the member, or null if the member should be created.
  final String? uuid;
}
