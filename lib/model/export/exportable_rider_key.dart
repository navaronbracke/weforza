import 'package:weforza/model/export/exportable_rider.dart';

/// The identifiable key for an [ExportableRider].
final class ExportableRiderKey {
  ExportableRiderKey({required this.alias, required this.firstName, required this.lastName})
    : assert(
        firstName.isNotEmpty && lastName.isNotEmpty,
        'The first name and last name of an exportable rider key cannot be empty',
      );

  factory ExportableRiderKey.fromRider(ExportableRider rider) {
    return ExportableRiderKey(alias: rider.alias, firstName: rider.firstName, lastName: rider.lastName);
  }

  /// The alias of the [ExportableRider].
  final String alias;

  /// The first name of the [ExportableRider].
  final String firstName;

  /// The last name of the [ExportableRider].
  final String lastName;

  @override
  bool operator ==(Object other) {
    return other is ExportableRiderKey &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        alias == other.alias;
  }

  @override
  int get hashCode => Object.hash(firstName, lastName, alias);
}
