import 'dart:ui';

///This class represents a 'Member.'
class Member {
  Member(this.uuid,this.firstname,this.lastname, this.alias,[this.profileImageFilePath]):
        assert(uuid != null && uuid.isNotEmpty && firstname != null && lastname != null && alias != null);

  ///Regex for a member's first or last name or alias.
  ///
  ///The Regex is language independent.
  ///Allows hyphen,apostrophe and spaces.
  ///Between 1 and 50 characters(inclusive).
  static final RegExp personNameRegex = RegExp(r"^([\p{Letter}\s]|['-]){1,50}$",unicode: true);

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
}