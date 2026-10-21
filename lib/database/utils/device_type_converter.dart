import 'package:drift/drift.dart';
import 'package:weforza/model/device/device_type.dart';

/// A [TypeConverter] for converting between [DeviceType] and its corresponding integer representation in the database.
final class DeviceTypeConverter extends TypeConverter<DeviceType, int> {
  const DeviceTypeConverter();

  @override
  DeviceType fromSql(int fromDb) => DeviceType.fromTypeIndex(fromDb);

  @override
  int toSql(DeviceType value) => value.typeIndex;
}
