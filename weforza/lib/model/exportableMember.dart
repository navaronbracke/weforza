import 'package:meta/meta.dart';

class ExportableMember {
  ExportableMember({
    @required this.firstName,
    @required this.lastName,
    @required this.alias,
    @required this.devices,
  }): assert(
    firstName != null && firstName.isNotEmpty && lastName != null &&
        lastName.isNotEmpty && alias != null && devices != null
  );

  final String firstName;
  final String lastName;
  final String alias;
  final List<String> devices;

  String toCsv(){
    final String devicesString = devices.isEmpty ? "" : ",${devices.join(",")}";
    return "$firstName,$lastName,$alias$devicesString";
  }

  //TODO when implementing import members from json -> should be compatible
  Map<String,dynamic> toJson(){
    return {
      "firstName": firstName,
      "lastName": lastName,
      "alias": alias,
      "devices": devices
    };
  }
}