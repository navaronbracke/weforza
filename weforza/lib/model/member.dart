import 'dart:ui';

///This class represents a 'Member.'
class Member implements Comparable<Member> {
  Member(this.uuid,this.firstname,this.lastname, this.alias,[this.profileImageFilePath]):
        assert(uuid != null && uuid.isNotEmpty && firstname != null && lastname != null && alias != null);

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
  String profileImageFilePath;

  String get initials => firstname[0] + lastname[0];

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "firstname": firstname,
      "lastname": lastname,
      "alias": alias,
      "profile": profileImageFilePath
    };
  }

  ///Create a member from a Map and a given uuid.
  static Member of(String uuid,Map<String,dynamic> values){
    assert(uuid != null && uuid.isNotEmpty && values != null);
    return Member(uuid,values["firstname"],values["lastname"],values["alias"],values["profile"]);
  }

  //If the uuid is the same, it is the same member.
  //Otherwise it is the same member if all the properties match.
  @override
  bool operator ==(Object other){
    return other is Member
        && firstname == other.firstname
        && lastname == other.lastname
        && alias == other.alias;
  }

  @override
  int get hashCode => hashValues(firstname, lastname, alias);

  Map<String, String> toJson() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "alias": alias
    };
  }

  String toCsv() => "$firstname,$lastname,$alias";

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