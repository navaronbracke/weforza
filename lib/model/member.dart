import 'package:weforza/extensions/date_extension.dart';

/// This class represents a member.
class Member implements Comparable<Member> {
  /// The default constuctor.
  Member({
    required this.uuid,
    required this.firstname,
    required this.lastname,
    required this.alias,
    required this.isActiveMember,
    required this.profileImageFilePath,
    required this.lastUpdated,
  }) : assert(uuid.isNotEmpty && firstname.isNotEmpty && lastname.isNotEmpty);

  /// Create a member from the given [uuid] and [values].
  factory Member.of(String uuid, Map<String, Object?> values) {
    assert(uuid.isNotEmpty);

    return Member(
      uuid: uuid,
      firstname: values['firstname'] as String,
      lastname: values['lastname'] as String,
      alias: values['alias'] as String? ?? '',
      isActiveMember: values['active'] as bool? ?? true,
      profileImageFilePath: values['profile'] as String?,
      lastUpdated: DateTime.parse(values['lastUpdated'] as String),
    );
  }

  /// Regex for a member's first or last name or alias.
  ///
  /// The Regex is language independent.
  /// Allows hyphen, apostrophe and spaces.
  /// Between 1 and 50 characters(inclusive).
  static final personNameAndAliasRegex = RegExp(
    r"^([\p{Letter}\s]|['-]){1,50}$",
    unicode: true,
  );

  static const int nameAndAliasMaxLength = 50;

  /// The member's GUID.
  final String uuid;

  /// The member's first name.
  String firstname;

  /// The member's last name.
  String lastname;

  /// The member's alias.
  String alias;

  /// The path to an optional profile picture.
  String? profileImageFilePath;

  /// Whether this member is currently an active ride participant.
  bool isActiveMember;

  /// The last time that this member was updated.
  final DateTime lastUpdated;

  /// The member initials.
  String get initials => firstname[0] + lastname[0];

  /// This member, as a Map.
  Map<String, Object?> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'alias': alias,
      'active': isActiveMember,
      'profile': profileImageFilePath,
      'lastUpdated': lastUpdated.toStringWithoutMilliseconds(),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Member &&
        firstname == other.firstname &&
        lastname == other.lastname &&
        alias == other.alias &&
        isActiveMember == other.isActiveMember;
  }

  @override
  int get hashCode => Object.hash(firstname, lastname, alias, isActiveMember);

  @override
  int compareTo(Member other) {
    final int deltaFirstName = firstname.compareTo(other.firstname);

    if (deltaFirstName != 0) {
      return deltaFirstName;
    }

    final int deltaLastName = lastname.compareTo(other.lastname);

    if (deltaLastName != 0) {
      return deltaLastName;
    }

    return alias.compareTo(other.alias);
  }
}
