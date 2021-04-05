import 'dart:ui';

/// This class serves as a wrapper during the import members phase.
/// It allows for using [firstName], [lastName] and [alias] as keys in a Map.
class ImportableMemberKey {
  ImportableMemberKey({
    required this.firstName,
    required this.lastName,
    required this.alias,
  }): assert(firstName.isNotEmpty && lastName.isNotEmpty);

  final String firstName;
  final String lastName;
  final String alias;

  @override
  bool operator ==(Object other) => other is ImportableMemberKey
      && firstName == other.firstName && lastName == other.lastName
      && alias == other.alias;

  @override
  int get hashCode => hashValues(firstName, lastName, alias);
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

  /// Convert [updatedOn] to a 'YYYY-MM-DD HH-MM-SSZ' string.
  /// E.g. 1969-07-20 20:18:04Z
  String _lastUpdatedToString(){
    final String s = updatedOn.toString();

    // Strip the milliseconds and append a Z.
    return s.substring(0, s.length - 4) + "Z";
  }

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "lastUpdated": _lastUpdatedToString(),
    };
  }

  @override
  bool operator ==(Object other) => other is ImportableMember
      && uuid == other.uuid && updatedOn == other.updatedOn;

  @override
  int get hashCode => hashValues(uuid, updatedOn);
}