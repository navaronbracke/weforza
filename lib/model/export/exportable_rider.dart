/// @docImport 'package:weforza/database/database.dart';
library;

/// A single [Rider], with its [Device]s, that can be serialized.
final class ExportableRider implements Comparable<ExportableRider> {
  /// Create a new [ExportableRider] with the provided [alias], [devices], [firstName], [isActive],
  /// [lastName] and [lastUpdated].
  ///
  /// The [lastUpdated] timestamp will be converted to UTC time.
  ExportableRider({
    required this.alias,
    required this.devices,
    required this.firstName,
    required this.isActive,
    required this.lastName,
    required DateTime lastUpdated,
  }) : assert(
         firstName.isNotEmpty && lastName.isNotEmpty,
         'The first name and last name of an exportable rider cannot be empty',
       ),
       lastUpdated = lastUpdated.toUtc();

  /// The alias of the rider.
  final String alias;

  /// The names of the devices that this rider owns.
  final Set<String> devices;

  /// The first name of the rider.
  final String firstName;

  /// Whether this rider is active.
  final bool isActive;

  /// The last name of the rider.
  final String lastName;

  /// The timestamp that indicates when this rider was last updated.
  final DateTime lastUpdated;

  /// Serialize this rider to a comma separated string.
  String toCsv() {
    final sb = StringBuffer('$firstName,$lastName,$alias,');

    sb.write('${isActive ? 1 : 0},');
    sb.write('${lastUpdated.toIso8601String()},');
    sb.write(devices.isEmpty ? '' : devices.join(','));

    return sb.toString();
  }

  /// Serialize this rider to a JSON object.
  Map<String, Object?> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'alias': alias,
      'isActive': isActive,
      'devices': devices.toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  int compareTo(ExportableRider other) {
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
    if (isActive && !other.isActive) {
      return -1;
    }

    if (!isActive && other.isActive) {
      return 1;
    }

    return 0;
  }
}
