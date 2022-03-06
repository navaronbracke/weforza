import 'package:weforza/extensions/date_extension.dart';

/// This class is used as format for exporting members.
class ExportableMember {
  ExportableMember({
    required this.firstName,
    required this.lastName,
    required this.alias,
    required this.isActiveMember,
    required this.devices,
    required this.lastUpdated,
  }) : assert(firstName.isNotEmpty && lastName.isNotEmpty);

  final bool isActiveMember;
  final String firstName;
  final String lastName;
  final String alias;
  final Set<String> devices;
  final DateTime lastUpdated;

  String toCsv() {
    final String devicesString = devices.isEmpty ? '' : devices.join(',');

    return '$firstName,$lastName,$alias,${isActiveMember ? 1 : 0},'
        '${lastUpdated.toStringWithoutMilliseconds()},$devicesString';
  }

  Map<String, Object?> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'alias': alias,
      'active': isActiveMember,
      'lastUpdated': lastUpdated.toStringWithoutMilliseconds(),
      'devices': devices.toList(),
    };
  }
}
