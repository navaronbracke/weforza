import 'package:weforza/extensions/date_extension.dart';

/// This class represents a rider.
class Rider implements Comparable<Rider> {
  /// The default constuctor.
  Rider({
    required this.active,
    required this.alias,
    required this.firstName,
    required this.lastName,
    required this.lastUpdated,
    required this.profileImageFilePath,
    required this.uuid,
  }) : assert(
          uuid.isNotEmpty && firstName.isNotEmpty && lastName.isNotEmpty,
          'The uuid, first name and last name of a rider should not be empty',
        );

  /// Create a rider from the given [uuid] and [values].
  factory Rider.of(String uuid, Map<String, Object?> values) {
    assert(uuid.isNotEmpty, 'The uuid of a rider should not be empty');

    return Rider(
      active: values['active'] as bool? ?? true,
      alias: values['alias'] as String? ?? '',
      firstName: values['firstname'] as String,
      lastName: values['lastname'] as String,
      lastUpdated: DateTime.parse(values['lastUpdated'] as String),
      profileImageFilePath: values['profile'] as String?,
      uuid: uuid,
    );
  }

  /// Regex for a rider's first name, last name or alias.
  ///
  /// The regex is language independent,
  /// allows hyphens, left and right single quotation marks and spaces,
  /// and requires a length between 1 and 50.
  static final personNameAndAliasRegex = RegExp(
    r'^([\p{L}\s]|[\u2018\u2019-]){1,50}$',
    unicode: true,
  );

  /// The maximum length for the first name, last name and alias.
  static const int nameAndAliasMaxLength = 50;

  /// Whether this rider is currently an active ride participant.
  final bool active;

  /// The rider's alias.
  final String alias;

  /// The rider's first name.
  final String firstName;

  /// The rider's last name.
  final String lastName;

  /// The last time that this rider was updated.
  final DateTime lastUpdated;

  /// The path to the rider's profile image on disk.
  final String? profileImageFilePath;

  /// The rider's UUID.
  final String uuid;

  /// Get the rider's initials.
  String get initials => firstName[0] + lastName[0];

  @override
  int compareTo(Rider other) {
    final int deltaFirstName = firstName.compareTo(other.firstName);

    if (deltaFirstName != 0) {
      return deltaFirstName;
    }

    final int deltaLastName = lastName.compareTo(other.lastName);

    if (deltaLastName != 0) {
      return deltaLastName;
    }

    return alias.compareTo(other.alias);
  }

  /// Convert this rider into a map.
  Map<String, Object?> toMap() {
    return {
      'active': active,
      'alias': alias,
      'firstname': firstName,
      'lastname': lastName,
      'lastUpdated': lastUpdated.toStringWithoutMilliseconds(),
      'profile': profileImageFilePath,
    };
  }

  @override
  int get hashCode {
    return Object.hash(
      uuid,
      firstName,
      lastName,
      alias,
      active,
      lastUpdated,
      profileImageFilePath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Rider &&
        uuid == other.uuid &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        alias == other.alias &&
        active == other.active &&
        lastUpdated == other.lastUpdated &&
        profileImageFilePath == other.profileImageFilePath;
  }
}
