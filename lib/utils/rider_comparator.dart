import 'package:weforza/database/database.dart';

mixin RiderComparator {
  /// Compare [rider] against [other].
  ///
  /// The [Rider] model cannot implement [Comparable] directly, since it is a generated class.
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
}
