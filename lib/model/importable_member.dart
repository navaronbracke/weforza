import 'package:weforza/extensions/date_extension.dart';

/// This class serves as a wrapper during the import members phase.
/// It allows for using [firstName], [lastName] and [alias] as keys in a Map.
class ImportableMemberKey {
  ImportableMemberKey({
    required this.firstName,
    required this.lastName,
    required this.alias,
  }) : assert(
          firstName.isNotEmpty && lastName.isNotEmpty,
          'The first name and last name of an importable member should not be empty',
        );

  final String firstName;
  final String lastName;
  final String alias;

  @override
  bool operator ==(Object other) {
    return other is ImportableMemberKey &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        alias == other.alias;
  }

  @override
  int get hashCode => Object.hash(firstName, lastName, alias);
}

/// This class serves as a wrapper during the import members phase.
/// It wraps only the [Member.lastUpdated] and [Member.uuid] fields.
/// It provides the updatable content for the import members phase.
class ImportableMember {
  ImportableMember({
    required this.uuid,
    required this.updatedOn,
  });

  final String uuid;
  final DateTime updatedOn;

  /// Convert this object to a Map.
  Map<String, dynamic> toMap() {
    return {'lastUpdated': updatedOn.toStringWithoutMilliseconds()};
  }

  @override
  bool operator ==(Object other) {
    return other is ImportableMember &&
        uuid == other.uuid &&
        updatedOn == other.updatedOn;
  }

  @override
  int get hashCode => Object.hash(uuid, updatedOn);
}
