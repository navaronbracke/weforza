import 'dart:ui';

///This class represents a 'Member.'
class Member implements Comparable<Member> {
  Member({
    required this.uuid,
    required this.firstname,
    required this.lastname,
    required this.alias,
    required this.isActiveMember,
    required this.profileImageFilePath
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
  String firstname;

  ///A member's last name.
  String lastname;

  ///A member's alias.
  String alias;

  ///The path to an optional profile picture.
  String? profileImageFilePath;

  // Whether this member is currently an active ride participant.
  bool isActiveMember;

  String get initials => firstname[0] + lastname[0];

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "firstname": firstname,
      "lastname": lastname,
      "alias": alias,
      "active": isActiveMember,
      "profile": profileImageFilePath
    };
  }

  ///Create a member from a Map and a given uuid.
  static Member of(String uuid,Map<String,dynamic> values){
    assert(uuid.isNotEmpty);
    return Member(
      uuid: uuid,
      firstname: values["firstname"],
      lastname: values["lastname"],
      alias: values["alias"],
      isActiveMember: values["active"],
      profileImageFilePath: values["profile"]
    );
  }

  //If the uuid is the same, it is the same member.
  //Otherwise it is the same member if all the properties match.
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

  Map<String, dynamic> toJson() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "alias": alias,
      "active": isActiveMember
    };
  }

  String toCsv() => "$firstname,$lastname,$alias,${isActiveMember ? 1: 0}";

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