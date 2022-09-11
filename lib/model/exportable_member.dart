import 'package:weforza/extensions/date_extension.dart';
import 'package:weforza/model/importable_member.dart';

/// This class represents an exportable member.
///
/// It is used for exporting members as well as importing members,
/// since the format should be interchangeable.
class ExportableMember {
  /// The default constructor.
  ExportableMember({
    required this.active,
    required this.alias,
    required this.devices,
    required this.firstName,
    required this.lastName,
    required this.lastUpdated,
  }) : assert(firstName.isNotEmpty && lastName.isNotEmpty);

  /// Whether this member is an active member.
  final bool active;

  /// The alias of the member.
  final String alias;

  /// The names of the devices that this member owns.
  final Set<String> devices;

  /// The first name of the member.
  final String firstName;

  /// The last name of the member.
  final String lastName;

  /// The timestamp that indicates the last update of this member.
  final DateTime lastUpdated;

  /// Get the import key for this importable member.
  ImportableMemberKey get importKey {
    return ImportableMemberKey(
      alias: alias,
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// Convert this object to a comma separated string.
  String toCsv() {
    final sb = StringBuffer('$firstName,$lastName,$alias,');

    sb.write('${active ? 1 : 0},');
    sb.write('${lastUpdated.toStringWithoutMilliseconds()},');
    sb.write(devices.isEmpty ? '' : devices.join(','));

    return sb.toString();
  }

  /// Convert this object to JSON.
  Map<String, Object?> toJson() {
    return {
      'active': active,
      'alias': alias,
      'devices': devices.toList(),
      'firstName': firstName,
      'lastName': lastName,
      'lastUpdated': lastUpdated.toStringWithoutMilliseconds(),
    };
  }
}
