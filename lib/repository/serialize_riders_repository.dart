import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/import_riders_dao.dart';
import 'package:weforza/database/rider_dao.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/rider/serializable_rider.dart';

/// This class represents the repository that handles (de)serializing riders.
class SerializeRidersRepository {
  SerializeRidersRepository(
    this.deviceDao,
    this.importRidersDao,
    this.riderDao,
  );

  final DeviceDao deviceDao;

  final ImportRidersDao importRidersDao;

  final RiderDao riderDao;

  /// Get the collection of serializable riders.
  Future<Iterable<SerializableRider>> getSerializableRiders() async {
    // Since Future.wait() expects the same datatypes from all Futures,
    // it cannot be used here. Instead, start (but not await) each computation.
    final devicesFuture = deviceDao.getAllDevicesGroupedByOwnerId();
    final ridersFuture = riderDao.getRiders(RiderFilterOption.all);

    final devices = await devicesFuture;
    final riders = await ridersFuture;

    return riders.map(
      (rider) => SerializableRider(
        active: rider.active,
        alias: rider.alias,
        devices: devices[rider.uuid] ?? <String>{},
        firstName: rider.firstName,
        lastName: rider.lastName,
        lastUpdated: rider.lastUpdated,
      ),
    );
  }

  /// Save the given serializable [riders] to disk.
  Future<void> saveSerializableRiders(Iterable<SerializableRider> riders) {
    return importRidersDao.saveSerializableRiders(riders);
  }
}
