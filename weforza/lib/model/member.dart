///This class represents a 'Member.'
class Member {
  Member(this.uuid,this.firstname,this.lastname,this.phone,this.devices,[this.profileImageFilePath]):
        assert(uuid != null && uuid.isNotEmpty && firstname != null && lastname != null && phone != null && devices != null);

  ///Regex for a member's first or last name.
  ///
  ///The Regex is language independent.
  ///Allows hyphen,apostrophe and spaces.
  ///Between 1 and 50 characters(inclusive).
  static final RegExp personNameRegex = RegExp(r"^([\p{Letter}\s]|['-]){1,50}$",unicode: true);

  ///Regex for a member's phone number.
  ///Allows 8 to 15 digits. (15 digits is the maximum according to the E.164 standard).
  static final RegExp phoneNumberRegex = RegExp(r"\d{8,15}");

  ///The member's GUID.
  final String uuid;

  ///A member's first name.
  String firstname;

  ///A member's last name.
  String lastname;

  ///A member's phone number.
  ///Note that [phone] is a String, integers can't do leading zeroes.
  String phone;

  ///The path to an optional profile picture.
  String profileImageFilePath;

  ///The list of devices of this person.
  ///We can only retrieve device name reliably with bluetooth, hence the String.
  final List<String> devices;

  ///Convert this object to a Map.
  Map<String,dynamic> toMap(){
    return {
      "firstname": firstname,
      "lastname": lastname,
      "phone": phone,
      "devices": devices,
      "profile": profileImageFilePath
    };
  }

  ///Create a member from a Map and a given uuid.
  static Member of(String uuid,Map<String,dynamic> values){
    assert(uuid != null && uuid.isNotEmpty && values != null);
    return Member(uuid,values["firstname"],values["lastname"],values["phone"],List.from(values["devices"]),values["prodile"]);
  }
}