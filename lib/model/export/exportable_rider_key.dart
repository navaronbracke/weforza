import 'package:weforza/database/database.dart';
import 'package:weforza/model/export/exportable_rider.dart';

/// The identifiable key for an [ExportableRider].
final class ExportableRiderKey {
  new({required this.alias, required this.firstName, required this.lastName})
    : assert(
        firstName.isNotEmpty && lastName.isNotEmpty,
        'The first name and last name of an exportable rider key cannot be empty',
      );

  factory fromRider(Rider rider) {
    return ExportableRiderKey(alias: rider.alias ?? '', firstName: rider.firstName, lastName: rider.lastName);
  }

  factory fromExportedRider(ExportableRider exportedRider) {
    return ExportableRiderKey(
      alias: exportedRider.alias,
      firstName: exportedRider.firstName,
      lastName: exportedRider.lastName,
    );
  }

  /// The alias of the [ExportableRider].
  final String alias;

  /// The first name of the [ExportableRider].
  final String firstName;

  /// The last name of the [ExportableRider].
  final String lastName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ExportableRiderKey &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        alias == other.alias;
  }

  @override
  int get hashCode => Object.hash(firstName, lastName, alias);
}
