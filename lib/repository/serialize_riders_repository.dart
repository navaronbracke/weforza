import 'package:weforza/database/device_dao.dart';
import 'package:weforza/database/import_riders_dao.dart';
import 'package:weforza/database/rider_dao.dart';
import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/rider/serializable_rider.dart';

/// This class represents the repository that handles (de)serializing riders.
class SerializeRidersRepository {
  SerializeRidersRepository(
    this.deviceDao,
    this.fileUriParser,
    this.importRidersDao,
    this.riderDao,
  );

  final DeviceDao deviceDao;

  final FileUriParser fileUriParser;

  final ImportRidersDao importRidersDao;

  final RiderDao riderDao;

  /// Get the collection of serializable riders.
  ///
  /// The returned list is sorted on the rider name, alias and active state.
  Future<Iterable<SerializableRider>> getSerializableRiders() async {
    final (devices, riders) = await (
      deviceDao.getAllDevicesGroupedByOwnerId(),
      riderDao.getRiders(RiderFilterOption.all, fileUriParser: fileUriParser),
    ).wait;

    final output = riders
        .map(
          (rider) => SerializableRider(
            active: rider.active,
            alias: rider.alias,
            devices: devices[rider.uuid] ?? <String>{},
            firstName: rider.firstName,
            lastName: rider.lastName,
            lastUpdated: rider.lastUpdated,
          ),
        )
        .toList();

    output.sort((s1, s2) => s1.compareTo(s2));

    return output;
  }

  /// Save the given serializable [riders] to disk.
  Future<void> saveSerializableRiders(Iterable<SerializableRider> riders) {
    return importRidersDao.saveSerializableRiders(riders, fileUriParser: fileUriParser);
  }
}
