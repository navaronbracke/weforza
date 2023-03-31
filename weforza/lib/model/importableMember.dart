import 'dart:ui';

/// This class serves as a wrapper during the import members phase.
/// It allows for using [firstName], [lastName] and [alias] as keys in a Map.
class ImportableMember {
  ImportableMember({
    required this.firstName,
    required this.lastName,
    required this.alias,
  }): assert(firstName.isNotEmpty && lastName.isNotEmpty);

  final String firstName;
  final String lastName;
  final String alias;

  @override
  bool operator ==(Object other) => other is ImportableMember
      && firstName == other.firstName && lastName == other.lastName
      && alias == other.alias;

  @override
  int get hashCode => hashValues(firstName, lastName, alias);
}