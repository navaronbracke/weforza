import 'package:drift/drift.dart';
import 'package:weforza/database/riders.dart';
import 'package:weforza/model/device/device_type.dart';

part 'database.g.dart';

/// The table for the rider Bluetooth devices in the application.
class Devices extends Table {
  /// The min/max length for the name of a device.
  static const ({int max, int min}) nameLength = (min: 1, max: 40);

  /// The creation date of this device.
  /// This creation date is not indicative of the actual creation date
  /// of the physical hardware item.
  DateTimeColumn get creationDate => dateTime().withDefault(currentDateAndTime)();

  /// The type of this device.
  IntColumn get deviceType => integer().map(const _DeviceTypeConverter())();

  /// The unique identifier for the device.
  ///
  /// This is an auto-increment id.
  IntColumn get id => integer().autoIncrement()();

  /// The human-readable name of the device.
  TextColumn get name => text().withLength(min: nameLength.min, max: nameLength.max)();

  /// The [Riders.id] of the owner of this device.
  IntColumn get ownerId => integer().references(Riders, #id, onDelete: .cascade)();
}

final class _DeviceTypeConverter extends TypeConverter<DeviceType, int> {
  const _DeviceTypeConverter();

  @override
  DeviceType fromSql(int fromDb) => DeviceType.fromTypeIndex(fromDb);

  @override
  int toSql(DeviceType value) => value.typeIndex;
}
