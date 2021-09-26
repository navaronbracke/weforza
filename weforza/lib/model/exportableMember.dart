
import 'package:weforza/extensions/date_extensions.dart';

/// This class is used as format for exporting members
class ExportableMember {
  ExportableMember({
    required this.firstName,
    required this.lastName,
    required this.alias,
    required this.isActiveMember,
    required this.devices,
    required this.lastUpdated,
  }): assert(firstName.isNotEmpty && lastName.isNotEmpty);

  final bool isActiveMember;
  final String firstName;
  final String lastName;
  final String alias;
  final Set<String> devices;
  final DateTime lastUpdated;

  String toCsv(){
    final String devicesString = devices.isEmpty ? "" : devices.join(",");
    return "$firstName,$lastName,$alias,${isActiveMember ? 1: 0},${lastUpdated.toStringSimple()},$devicesString";
  }

  Map<String,dynamic> toJson(){
    return {
      "firstName": firstName,
      "lastName": lastName,
      "alias": alias,
      "active": isActiveMember,
      "lastUpdated": lastUpdated.toStringSimple(),
      "devices": List<String>.of(devices)
    };
  }
}