///This class represents a 'Member.'
///
///A member has a first name, last name and a phone number.
class Member {
  ///Regex for a member's first or last name.
  ///
  ///The Regex is language independent.
  ///Allows hyphen,apostrophe and spaces.
  ///Between 1 and 50 characters(inclusive).
  static final RegExp personNameRegex = RegExp(r"^([\p{Letter}\s]|['-]){1,50}$",unicode: true);

  ///Regex for a member's phone number.
  ///Allows 8 to 15 digits. (15 digits is the maximum according to the E.164 standard).
  static final RegExp phoneNumberRegex = RegExp(r"\d{8,15}");

  Member(this.firstname,this.lastname,this.phone,this.devices,[this.wasPresentCount = 0,this.profileImageFilePath]): assert(firstname != null && lastname != null && phone != null && devices != null);

  ///An id for in the database.
  int id;

  ///A member's first name.
  String firstname;

  ///A member's last name.
  String lastname;

  ///A member's phone number.
  ///Note that [_phone] is a String, integers can't do leading zeroes.
  String phone;

  ///The path to the image file, that was chosen as profile picture.
  String profileImageFilePath;

  ///A member's number of times he/she was present.
  int wasPresentCount;
  ///The list of devices of this person.
  ///We can only retrieve device name reliably with bluetooth, hence the String.
  List<String> devices;

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "firstname": firstname,
      "lastname": lastname,
      "phone": phone,
      "wasPresentCount": wasPresentCount,
      "devices": devices,
      "profile": profileImageFilePath
    };
  }

  ///Create a Member from a Map.
  static Member fromMap(Map<String,dynamic> map) {
    return Member(
      map["firstname"],
      map["lastname"],
      map["phone"],
      List.from(map["devices"]),
      map["wasPresentCount"],
      map["profile"]
    );
  }
}