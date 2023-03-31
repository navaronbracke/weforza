import 'package:weforza/extensions/date_extension.dart';

/// This class represents a single rider that can be (de)serialized.
class SerializableRider {
  /// The default constructor.
  SerializableRider({
    required this.active,
    required this.alias,
    required this.devices,
    required this.firstName,
    required this.lastName,
    required this.lastUpdated,
  }) : assert(
          firstName.isNotEmpty && lastName.isNotEmpty,
          'The first name and last name of a serializable rider cannot be empty',
        );

  /// Whether this rider is active.
  final bool active;

  /// The alias of the rider.
  final String alias;

  /// The names of the devices that this rider owns.
  final Set<String> devices;

  /// The first name of the rider.
  final String firstName;

  /// The last name of the rider.
  final String lastName;

  /// The timestamp that indicates when this rider was last updated.
  final DateTime lastUpdated;

  /// Get the identifying serialization key for this rider.
  SerializableRiderKey get key {
    return SerializableRiderKey(
      alias: alias,
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// Serialize this rider to a comma separated string.
  String toCsv() {
    final sb = StringBuffer('$firstName,$lastName,$alias,');

    sb.write('${active ? 1 : 0},');
    sb.write('${lastUpdated.toStringWithoutMilliseconds()},');
    sb.write(devices.isEmpty ? '' : devices.join(','));

    return sb.toString();
  }

  /// Serialize this rider to a JSON object.
  Map<String, Object?> toJson() {
    return {
      'active': active,
      'alias': alias,
      'devices': devices.toList(),
      'firstName': firstName,
      'lastName': lastName,
      'lastUpdated': lastUpdated.toStringWithoutMilliseconds(),
    };
  }
}

/// This class represents a [SerializableRider]
/// as an identifying key that uses only the name of the rider.
///
/// This class is typically used as a key in a [Map].
class SerializableRiderKey {
  SerializableRiderKey({
    required this.alias,
    required this.firstName,
    required this.lastName,
  }) : assert(
          firstName.isNotEmpty && lastName.isNotEmpty,
          'The first name and last name of a serializable rider key cannot be empty',
        );

  /// The alias of the [SerializableRider].
  final String alias;

  /// The first name of the [SerializableRider].
  final String firstName;

  /// The last name of the [SerializableRider].
  final String lastName;

  @override
  bool operator ==(Object other) {
    return other is SerializableRiderKey &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        alias == other.alias;
  }

  @override
  int get hashCode => Object.hash(firstName, lastName, alias);
}

/// This class represents the timestamp
/// of the last update of a [SerializableRider].
class SerializableRiderUpdateTimestamp {
  /// The default constructor.
  const SerializableRiderUpdateTimestamp({
    required this.lastUpdatedOn,
    required this.uuid,
  });

  /// The timestamp of the last update
  /// of the [SerializableRider] with the given [uuid].
  final DateTime lastUpdatedOn;

  /// The uuid of the [SerializableRider] that was updated.
  final String uuid;

  /// Convert this object to a map.
  Map<String, Object?> toMap() {
    return {'lastUpdated': lastUpdatedOn.toStringWithoutMilliseconds()};
  }

  @override
  bool operator ==(Object other) {
    return other is SerializableRiderUpdateTimestamp &&
        uuid == other.uuid &&
        lastUpdatedOn == other.lastUpdatedOn;
  }

  @override
  int get hashCode => Object.hash(uuid, lastUpdatedOn);
}
