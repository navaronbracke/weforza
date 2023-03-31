import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/import_riders_dao.dart';
import 'package:weforza/database/member_dao.dart';
import 'package:weforza/model/member_filter_option.dart';
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

  final MemberDao riderDao;

  /// Get the collection of serializable riders.
  Future<Iterable<SerializableRider>> getSerializableRiders() async {
    // Since Future.wait() expects the same datatypes from all Futures,
    // it cannot be used here. Instead, start (but not await) each computation.
    final devicesFuture = deviceDao.getAllDevicesGroupedByOwnerId();
    final ridersFuture = riderDao.getMembers(MemberFilterOption.all);

    final devices = await devicesFuture;
    final riders = await ridersFuture;

    return riders.map(
      (member) => SerializableRider(
        active: member.active,
        alias: member.alias,
        devices: devices[member.uuid] ?? <String>{},
        firstName: member.firstName,
        lastName: member.lastName,
        lastUpdated: member.lastUpdated,
      ),
    );
  }

  /// Save the given serializable [riders] to disk.
  Future<void> saveSerializableRiders(Iterable<SerializableRider> riders) {
    return importRidersDao.saveSerializableRiders(riders);
  }
}
