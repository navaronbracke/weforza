import 'dart:io';

/// This class represents the model to add or edit a rider.
class RiderModel {
  /// The default constructor.
  const RiderModel({
    required this.alias,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.uuid,
    this.active = true,
  });

  /// Whether this rider is an active rider.
  final bool active;

  /// The alias for the rider.
  final String alias;

  /// The first name for the rider.
  final String firstName;

  /// The last name for the rider.
  final String lastName;

  /// The file that represents the rider's profile image.
  final File? profileImage;

  /// The uuid of the rider, or null if the rider should be created.
  final String? uuid;
}
