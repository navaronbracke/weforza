import 'package:weforza/extensions/date_extension.dart';
import 'package:weforza/model/rider/rider.dart';

/// This class represents a single rider that can be (de)serialized.
class SerializableRider implements Comparable<SerializableRider> {
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

  /// Create a [SerializableRider] from a [Rider] and a collection of [devices] per rider.
  factory SerializableRider.fromRider(Rider rider, Map<String, Set<String>> devices) {
    return SerializableRider(
      active: rider.active,
      alias: rider.alias,
      devices: devices[rider.uuid] ?? <String>{},
      firstName: rider.firstName,
      lastName: rider.lastName,
      lastUpdated: rider.lastUpdated,
    );
  }

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
    return SerializableRiderKey(alias: alias, firstName: firstName, lastName: lastName);
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

  @override
  int compareTo(SerializableRider other) {
    final firstNameComparison = firstName.compareTo(other.firstName);

    if (firstNameComparison != 0) {
      return firstNameComparison;
    }

    final lastNameComparison = lastName.compareTo(other.lastName);

    if (lastNameComparison != 0) {
      return lastNameComparison;
    }

    // Both aliases are empty, thus both are equal.
    if (alias.isEmpty && other.alias.isEmpty) {
      return 0;
    }

    // This object has more priority based on its alias.
    if (alias.isNotEmpty && other.alias.isEmpty) {
      return -1;
    }

    // This object has less priority based on its alias.
    if (alias.isEmpty && other.alias.isNotEmpty) {
      return 1;
    }

    // Both have non-empty aliases, compare them.
    final aliasComparison = alias.compareTo(other.alias);

    if (aliasComparison != 0) {
      return aliasComparison;
    }

    // As a last resort, compare the active states.
    if (active && !other.active) {
      return -1;
    }

    if (!active && other.active) {
      return 1;
    }

    return 0;
  }
}

/// This class represents a [SerializableRider]
/// as an identifying key that uses only the name of the rider.
///
/// This class is typically used as a key in a [Map].
class SerializableRiderKey {
  SerializableRiderKey({required this.alias, required this.firstName, required this.lastName})
    : assert(
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
  const SerializableRiderUpdateTimestamp({required this.lastUpdatedOn, required this.uuid});

  /// The timestamp of the last update
  /// of the [SerializableRider] with the given [uuid].
  final DateTime lastUpdatedOn;

  /// The uuid of the [SerializableRider] that was updated.
  final String uuid;

  /// Convert this object to a map.
  @Deprecated('Insert this object directly into the database using an insert or update query')
  Map<String, Object?> toMap() {
    return {'lastUpdated': lastUpdatedOn.toStringWithoutMilliseconds()};
  }

  @override
  bool operator ==(Object other) {
    return other is SerializableRiderUpdateTimestamp && uuid == other.uuid && lastUpdatedOn == other.lastUpdatedOn;
  }

  @override
  int get hashCode => Object.hash(uuid, lastUpdatedOn);
}
