import 'package:meta/meta.dart';

/// This class is used as format for exporting members
class ExportableMember {
  ExportableMember({
    @required this.firstName,
    @required this.lastName,
    @required this.alias,
    @required this.isActiveMember,
    @required this.devices,
  }): assert(
    firstName != null && firstName.isNotEmpty
        && lastName != null && lastName.isNotEmpty && alias != null
        && devices != null && isActiveMember != null
  );

  final bool isActiveMember;
  final String firstName;
  final String lastName;
  final String alias;
  final Set<String> devices;

  String toCsv(){
    final String devicesString = devices.isEmpty ? "" : ",${devices.join(",")}";
    return "$firstName,$lastName,$alias,${isActiveMember ? 1: 0},$devicesString";
  }

  Map<String,dynamic> toJson(){
    return {
      "firstName": firstName,
      "lastName": lastName,
      "alias": alias,
      "active": isActiveMember,
      "devices": List<String>.of(devices)
    };
  }
}