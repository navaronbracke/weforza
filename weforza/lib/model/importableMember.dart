import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// This class serves as a wrapper during the import members phase.
/// It allows for using [firstName], [lastName] and [alias] as keys in a Map.
class ImportableMember {
  ImportableMember({
    @required this.firstName,
    @required this.lastName,
    @required this.alias,
    @required this.isActiveMember,
  }): assert(
    firstName != null && firstName.isNotEmpty && lastName != null &&
        lastName.isNotEmpty && alias != null && isActiveMember != null
  );

  final String firstName;
  final String lastName;
  final String alias;
  final bool isActiveMember;

  @override
  bool operator ==(Object other) => other is ImportableMember
      && firstName == other.firstName && lastName == other.lastName
      && alias == other.alias;

  @override
  int get hashCode => hashValues(firstName, lastName, alias);
}