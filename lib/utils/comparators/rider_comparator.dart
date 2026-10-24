import 'package:weforza/database/database.dart';

/// Compare [rider] against [other].
///
/// TODO: figure out if this can be removed with augmentations implementing Comparable directly.
int compareRiders(Rider rider, Rider other) {
  final int deltaFirstName = rider.firstName.compareTo(other.firstName);

  if (deltaFirstName != 0) {
    return deltaFirstName;
  }

  final int deltaLastName = rider.lastName.compareTo(other.lastName);

  if (deltaLastName != 0) {
    return deltaLastName;
  }

  final alias = rider.alias ?? '';

  return alias.compareTo(other.alias ?? '');
}
