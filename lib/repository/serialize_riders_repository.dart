import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/export/exportable_rider.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

/// This class represents the repository that handles (de)serializing riders.
class SerializeRidersRepository {
  SerializeRidersRepository(this._deviceRepository, this._riderRepository);

  final DeviceRepository _deviceRepository;
  final RiderRepository _riderRepository;

  /// Get the collection of [ExportableRider]s.
  ///
  /// The returned list is sorted on the rider name, alias and active state.
  Future<Iterable<ExportableRider>> getSerializableRiders() async {
    final (devices, riders) = await (
      _deviceRepository.getAllDevicesGroupedByOwnerId(),
      _riderRepository.getRiders(.all),
    ).wait;

    final output = [
      for (final rider in riders)
        ExportableRider(
          alias: rider.alias ?? '',
          firstName: rider.firstName,
          lastName: rider.lastName,
          isActive: rider.isActive,
          devices: devices[rider.id] ?? const {},
        ),
    ];

    output.sort((s1, s2) => s1.compareTo(s2));

    return output;
  }

  /// Save the given serializable [riders] to disk.
  Future<void> saveSerializableRiders(Iterable<SerializableRider> riders) {
    return importRidersDao.saveSerializableRiders(riders, fileUriParser: fileUriParser);
  }
}
