import 'package:drift/drift.dart';

/// The table for the excluded terms for a Bluetooth device scan.
class ExcludedTerms extends Table {
  /// The min/max length for the excluded term.
  static const ({int min, int max}) termLength = (min: 1, max: 48);

  /// The excluded term itself.
  TextColumn get term => text().withLength(min: termLength.min, max: termLength.max)();

  @override
  Set<Column<Object>> get primaryKey => {term};
}
