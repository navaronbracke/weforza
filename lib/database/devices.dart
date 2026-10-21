import 'package:drift/drift.dart';
import 'package:weforza/database/riders.dart';
import 'package:weforza/database/utils/device_type_converter.dart';
import 'package:weforza/database/utils/tiny_int_sql_type.dart';

/// The table for the rider Bluetooth devices.
class Devices extends Table {
  /// The validation [RegExp] for the device [name].
  static final RegExp deviceNameRegex = RegExp(r'^[^,]{1,40}$');

  /// The min/max length for the name of a device.
  static const ({int min, int max}) nameLength = (min: 1, max: 40);

  /// The creation date of this device, in _**local time**_.
  ///
  /// Use [DateTime.toUtc] to convert the date back to UTC.
  ///
  /// This creation date is not indicative of the actual creation date
  /// of the physical hardware item.
  DateTimeColumn get creationDate => dateTime().withDefault(currentDateAndTime)();

  /// The type of this device.
  ///
  /// Since this is an enum, it is stored as a `TINYINT` in the database.
  /// The [intEnum] column is not used, since this enum defines its own stable indexes.
  IntColumn get deviceType => customType(const TinyIntSqlType()).map(const DeviceTypeConverter())();

  /// The unique identifier for the device.
  ///
  /// This is an auto-increment id.
  IntColumn get id => integer().autoIncrement()();

  /// The human-readable name of the device.
  TextColumn get name => text().withLength(min: nameLength.min, max: nameLength.max)();

  /// The [Riders.id] of the owner of this device.
  ///
  /// If the owner is deleted, this device record is deleted as well.
  IntColumn get ownerId => integer().references(Riders, #id, onDelete: .cascade)();
}
