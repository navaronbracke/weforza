import 'package:drift/drift.dart';
import 'package:weforza/database/utils/uri_converter.dart';

/// The table for the riders.
class Riders extends Table {
  /// The min/max length for the first name, last name and alias.
  static const ({int min, int max}) nameAndAliasLength = (min: 1, max: 50);

  /// The [RegExp] for a rider's first name, last name or alias.
  ///
  /// The regex is language independent,
  /// allows hyphens, left and right single quotation marks and spaces,
  /// and requires a length between 1 and 50.
  static final nameAndAliasRegex = RegExp(r'^([\p{L}\s]|[\u2018\u2019-]){1,50}$', unicode: true);

  /// The optional alias of the rider.
  TextColumn get alias => text().nullable().withLength(min: nameAndAliasLength.min, max: nameAndAliasLength.max)();

  /// The first name of the rider.
  TextColumn get firstName => text().withLength(min: nameAndAliasLength.min, max: nameAndAliasLength.max)();

  /// The unique identifier for the rider.
  ///
  /// This is an auto-increment id.
  IntColumn get id => integer().autoIncrement()();

  /// Whether the rider is considered active.
  ///
  /// Defaults to true.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// The last name of the rider.
  TextColumn get lastName => text().withLength(min: nameAndAliasLength.min, max: nameAndAliasLength.max)();

  /// The last time the rider's information was updated, in _**local time**_.
  ///
  /// Use [DateTime.toUtc] to convert the date back to UTC.
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();

  /// The [Uri] of the profile image for the rider.
  TextColumn get profileImageUri => text().nullable().map(const UriConverter())();
}
