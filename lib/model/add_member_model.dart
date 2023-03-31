import 'dart:io';

/// This class represents the model to add a new member.
class AddMemberModel {
  /// The default constructor.
  const AddMemberModel({
    required this.alias,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  /// The alias for the member.
  final String alias;

  /// The first name for the member.
  final String firstName;

  /// The last name for the member.
  final String lastName;

  /// The file that represents the member's profile image.
  final Future<File?> profileImage;
}
