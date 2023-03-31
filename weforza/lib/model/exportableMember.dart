
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
    return "$firstName,$lastName,$alias,${isActiveMember ? 1: 0},${_lastUpdatedToString()},$devicesString";
  }

  /// Convert [lastUpdated] to a 'YYYY-MM-DD HH-MM-SSZ' string.
  /// E.g. 1969-07-20 20:18:04Z
  String _lastUpdatedToString(){
    final String s = lastUpdated.toString();

    // Strip the milliseconds and append a Z.
    return s.substring(0, s.length - 4) + "Z";
  }

  Map<String,dynamic> toJson(){
    return {
      "firstName": firstName,
      "lastName": lastName,
      "alias": alias,
      "active": isActiveMember,
      "lastUpdated": _lastUpdatedToString(),
      "devices": List<String>.of(devices)
    };
  }
}