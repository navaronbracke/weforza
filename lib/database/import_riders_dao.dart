import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/database/database_tables.dart';
import 'package:weforza/model/device/device.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/rider/serializable_rider.dart';

/// This class defines an interface for importing [SerializableRider]s.
abstract class ImportRidersDao {
  /// Save the given [riders].
  Future<void> saveSerializableRiders(Iterable<SerializableRider> riders);
}

/// The default implementation of [ImportRidersDao].
class ImportRidersDaoImpl implements ImportRidersDao {
  ImportRidersDaoImpl(this._database);

  /// A reference to the database.
  final Database _database;

  /// A reference to the [Device] store.
  final _deviceStore = DatabaseTables.device;

  /// A reference to the [Rider] store.
  final _riderStore = DatabaseTables.member;

  /// Get all the existing devices.
  /// Returns a map of device names per owner uuid.
  Future<Map<String, Set<String>>> _getExistingDevices() async {
    final collection = <String, Set<String>>{};

    final records = await _deviceStore.find(_database);

    for (final record in records) {
      final Device device = Device.of(record.key, record.value);

      if (collection[device.ownerId] == null) {
        collection[device.ownerId] = <String>{device.name};
      } else {
        collection[device.ownerId]!.add(device.name);
      }
    }

    return collection;
  }

  /// Get the existing riders.
  /// Returns a map of [Rider]s mapped to their respective [SerializableRiderKey]s.
  Future<Map<SerializableRiderKey, Rider>> _getExistingRiders() async {
    final collection = <SerializableRiderKey, Rider>{};

    final records = await _riderStore.find(_database);

    for (final record in records) {
      final key = SerializableRiderKey(
        alias: record.value['alias'] as String,
        firstName: record.value['firstname'] as String,
        lastName: record.value['lastname'] as String,
      );

      if (collection[key] == null) {
        collection[key] = Rider.of(record.key, record.value);
      }
    }

    return collection;
  }

  @override
  Future<void> saveSerializableRiders(
    Iterable<SerializableRider> riders,
  ) async {
    // Since Future.wait() expects the same datatypes from all Futures,
    // it cannot be used here. Instead, start (but not await) each computation.
    final existingDevicesFuture = _getExistingDevices();
    final existingRidersFuture = _getExistingRiders();

    final existingDevices = await existingDevicesFuture;
    final existingRiders = await existingRidersFuture;

    // The existing riders that should be updated.
    final ridersToUpdate = <SerializableRiderUpdateTimestamp>{};

    // The new riders that should be added.
    final newRiders = <Rider>{};

    // The new devices that should be added.
    final newDevices = <Device>{};

    const uuidGenerator = Uuid();

    for (final rider in riders) {
      final existingRider = existingRiders[rider.key];

      // The rider does not yet exist.
      // Add a new rider along with its devices.
      if (existingRider == null) {
        final uuid = uuidGenerator.v4();

        newRiders.add(
          Rider(
            active: rider.active,
            alias: rider.alias,
            firstName: rider.firstName,
            lastName: rider.lastName,
            lastUpdated: rider.lastUpdated,
            profileImageFilePath: null,
            uuid: uuid,
          ),
        );

        for (final device in rider.devices) {
          newDevices.add(
            Device(
              creationDate: DateTime.now(),
              name: device,
              ownerId: uuid,
            ),
          );
        }

        continue;
      }

      final uuid = existingRider.uuid;

      // The exported rider is newer than the existing rider.
      // Update the timestamp of the last update,
      // and add any new devices for this rider.
      if (rider.lastUpdated.isAfter(existingRider.lastUpdated)) {
        ridersToUpdate.add(
          SerializableRiderUpdateTimestamp(
            uuid: uuid,
            lastUpdatedOn: rider.lastUpdated,
          ),
        );

        final riderExistingDevices = existingDevices[uuid] ?? {};

        for (final device in rider.devices) {
          // Skip existing devices for this rider.
          if (riderExistingDevices.contains(device)) {
            continue;
          }

          newDevices.add(
            Device(creationDate: DateTime.now(), name: device, ownerId: uuid),
          );
        }
      }
    }

    await _database.transaction((txn) async {
      // Update the existing riders.
      await _riderStore
          .records(ridersToUpdate.map((r) => r.uuid))
          .update(txn, ridersToUpdate.map((r) => r.toMap()).toList());

      // Add the new riders.
      await _riderStore
          .records(newRiders.map((r) => r.uuid))
          .add(txn, newRiders.map((r) => r.toMap()).toList());

      // Add the new devices.
      await _deviceStore
          .records(newDevices.map((d) => d.creationDate.toIso8601String()))
          .add(txn, newDevices.map((d) => d.toMap()).toList());
    });
  }
}
