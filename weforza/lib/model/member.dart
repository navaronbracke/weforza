import 'dart:ui';
import 'package:weforza/cipher/cipher.dart';

///This class represents a 'Member.'
class Member implements Comparable<Member> {
  Member({
    required this.uuid,
    required this.firstname,
    required this.lastname,
    required this.alias,
    required this.isActiveMember,
    required this.profileImageFilePath,
    required this.lastUpdated,
  }): assert(uuid.isNotEmpty && firstname.isNotEmpty && lastname.isNotEmpty);

  ///Regex for a member's first or last name or alias.
  ///
  ///The Regex is language independent.
  ///Allows hyphen,apostrophe and spaces.
  ///Between 1 and 50 characters(inclusive).
  static final RegExp personNameAndAliasRegex = RegExp(r"^([\p{Letter}\s]|['-]){1,50}$",unicode: true);

  ///The member's GUID.
  final String uuid;

  ///A member's first name.
  final String firstname;

  ///A member's last name.
  final String lastname;

  ///A member's alias.
  final String alias;

  ///The path to an optional profile picture.
  String? profileImageFilePath;

  // Whether this member is currently an active ride participant.
  bool isActiveMember;

  // A date that tracks the last update timestamp.
  final DateTime lastUpdated;

  String get initials => firstname[0] + lastname[0];

  /// Convert this object to a Map, encrypting sensitive values.
  Map<String,dynamic> encrypt(Cipher cipher){
    return {
      "firstname": cipher.encrypt(firstname),
      "lastname": cipher.encrypt(lastname),
      "alias": alias.isEmpty ? alias : cipher.encrypt(alias),
      "active": isActiveMember,
      "profile": profileImageFilePath,
      "lastUpdated": lastUpdated.toIso8601String(),
    };
  }

  /// Create a member from a Map and a given uuid,
  /// while decrypting sensitive values with the [Cipher].
  static Member decrypt(String uuid, Map<String, dynamic> values, Cipher cipher){
    assert(uuid.isNotEmpty);
    final alias = values["alias"] as String;

    return Member(
      uuid: uuid,
      firstname: cipher.decrypt(values["firstname"]),
      lastname: cipher.decrypt(values["lastname"]),
      alias: alias.isEmpty ? alias : cipher.decrypt(alias),
      isActiveMember: values["active"],
      profileImageFilePath: values["profile"],
      lastUpdated: DateTime.parse(values["lastUpdated"]),
    );
  }

  @override
  bool operator ==(Object other){
    return other is Member
        && firstname == other.firstname
        && lastname == other.lastname
        && alias == other.alias
        && isActiveMember == other.isActiveMember;
  }

  @override
  int get hashCode => hashValues(firstname, lastname, alias, isActiveMember);

  ///Compare two members for use in sorting.
  ///Returns zero if both are considered equal.
  ///Returns a negative number if this object is regarded to be before [other] in a sorted list.
  ///Returns a positive number otherwise.
  @override
  int compareTo(Member other) {
    final int deltaFirstName = firstname.compareTo(other.firstname);

    if(deltaFirstName != 0){
      return deltaFirstName;
    }

    final int deltaLastName = lastname.compareTo(other.lastname);

    if(deltaLastName != 0){
      return deltaLastName;
    }

    return alias.compareTo(other.alias);
  }
}