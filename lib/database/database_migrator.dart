import 'dart:convert' show jsonDecode;

import 'package:drift/drift.dart' show Value;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file/memory.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/excluded_terms.dart';
import 'package:weforza/model/device/device_type.dart';

/// This class migrates the old database format to the new Drift format.
///
/// The old database is a text file, with each line being a JSON object.
///
/// The first line is the version specifier, i.e. `{"version":1,"sembast":1}`
/// Subsequent lines are individual records, as individual JSON objects.
///
/// Each record line has a `key`, corresponding to the key of the record.
///
/// For example `{"key":"2026-10-17T00:00:00.000","store":"ride","value":{"scannedAttendees":null}}`
final class DatabaseMigrator {
  /// Create a new [DatabaseMigrator] instance for use with the [LocalFileSystem].
  new(this._database)
    : _fileSystem = const LocalFileSystem(),
      _getDatabaseDirectory = _getApplicationSupportDirectory,
      _closeDatabaseAfterMigration = true;

  /// Create a new [DatabaseMigrator] instance for testing.
  new test(this._database, {required MemoryFileSystem this._fileSystem, required this._getDatabaseDirectory})
    : _closeDatabaseAfterMigration = false;

  /// The name of the old database file.
  static const String oldDatabaseName = 'weforza_database.db';

  /// The name of the settings key for the scan excluded terms filter in the settings record or shared preferences.
  static const String scanExcludedTermsFilterKey = 'scanExcludedTermsFilter';

  /// Whether to close the [WeForzaDatabase] after the migration is completed.
  ///
  /// This is true by default, unless using the [DatabaseMigrator.test] constructor,
  /// which explicitly disables automatic closing of the database.
  final bool _closeDatabaseAfterMigration;

  /// The new database instance to which the old data will be migrated.
  final WeForzaDatabase _database;

  /// The file system used to access the database file.
  final FileSystem _fileSystem;

  /// The function that provides the directory where the database file is stored.
  final Future<Directory> Function(FileSystem fileSystem) _getDatabaseDirectory;

  /// Get the application support directory, using the given [fileSystem].
  static Future<Directory> _getApplicationSupportDirectory(FileSystem fileSystem) {
    return getApplicationSupportDirectory().then((directory) => fileSystem.directory(directory.path));
  }

  /// Get the old database file.
  Future<File> _getOldDatabaseFile() async {
    final Directory oldDatabaseDir = await _getDatabaseDirectory(_fileSystem);

    return _fileSystem.file(join(oldDatabaseDir.path, oldDatabaseName));
  }

  /// Migrate the old database data to the new [WeForzaDatabase].
  ///
  /// Does nothing if the old database file does not exist, or is not a valid Sembast database file.
  /// Otherwise the old database file is deleted after its records were written to the new [WeForzaDatabase].
  ///
  /// By default the migration closes the [WeForzaDatabase] after it is complete.
  ///
  /// See [DatabaseMigrator.test], which does not explicitly close the database after the migration.
  Future<void> migrate() async {
    final File oldDatabaseFile = await _getOldDatabaseFile();

    if (!oldDatabaseFile.existsSync()) {
      return;
    }

    final List<String> oldDatabaseLines = await oldDatabaseFile.readAsLines();

    // If the old database file is invalid, just delete it.
    if (oldDatabaseLines.isEmpty || !_isValidDatabaseVersion(oldDatabaseLines.first.trim())) {
      await oldDatabaseFile.delete();

      return;
    }

    final prefs = SharedPreferencesAsync();

    // Pop the excluded terms list from shared preferences, these will be moved to the new database.
    final List<String>? sharedPreferencesExcludedTermsFilter = await prefs.getStringList(scanExcludedTermsFilterKey);
    if (sharedPreferencesExcludedTermsFilter != null) {
      await prefs.remove(scanExcludedTermsFilterKey);
    }

    final _ExtractedData extractedData = _parseDatabaseLines(
      oldDatabaseLines,
      sharedPreferencesExcludedTermsFilter: sharedPreferencesExcludedTermsFilter ?? const [],
    );

    try {
      await _writeRecords(_database, extractedData);
    } finally {
      if (_closeDatabaseAfterMigration) {
        await _database.close();
      }
    }

    await oldDatabaseFile.delete();
  }

  Future<void> _writeRecords(WeForzaDatabase database, _ExtractedData data) {
    return database.transaction(() async {
      final Map<String, int> riderIds = {};

      for (final rider in data.riders.values) {
        riderIds[rider.uuid] = await database
            .into(database.riders)
            .insert(
              RidersCompanion.insert(
                alias: Value(rider.alias),
                firstName: rider.firstName,
                isActive: Value(rider.active),
                lastName: rider.lastName,
                profileImageUri: Value(rider.profileImage),
              ),
            );
      }

      final Map<DateTime, int> rideIds = {};

      for (final ride in data.rides.values) {
        rideIds[ride.date] = await database
            .into(database.rides)
            .insert(RidesCompanion.insert(date: ride.date, scannedAttendees: Value(ride.scannedAttendees)));
      }

      for (final device in data.devices.values) {
        final int? ownerId = riderIds[device.ownerId];

        if (ownerId == null) {
          continue;
        }

        await database
            .into(database.devices)
            .insert(DevicesCompanion.insert(deviceType: device.type, name: device.name, ownerId: ownerId));
      }

      for (final attendee in data.rideAttendees.values) {
        final int? riderId = riderIds[attendee.uuid];
        final int? rideId = rideIds[attendee.rideDate];

        if (riderId == null || rideId == null) {
          continue;
        }

        await database
            .into(database.rideAttendees)
            .insert(
              RideAttendeesCompanion.insert(isScanned: Value(attendee.isScanned), rideId: rideId, riderId: riderId),
              mode: .insertOrIgnore,
            );
      }

      for (final term in data.excludedTermsFilter) {
        await database
            .into(database.excludedTerms)
            .insert(ExcludedTermsCompanion.insert(term: term), mode: .insertOrIgnore);
      }
    });
  }

  bool _isValidDatabaseVersion(String line) {
    try {
      final Map<String, Object?> parsedLine = jsonDecode(line) as Map<String, Object?>;

      return switch (parsedLine) {
        {'version': int _, 'sembast': int _} => true,
        _ => false,
      };
    } catch (_) {
      return false;
    }
  }

  _ExtractedData _parseDatabaseLines(List<String> lines, {required List<String> sharedPreferencesExcludedTermsFilter}) {
    // Later lines override earlier lines with the same key, so the records are keyed.
    final Map<String, _ExtractedRide> extractedRides = {};
    final Map<String, _ExtractedRider> extractedRiders = {};
    final Map<String, _ExtractedDevice> extractedDevices = {};
    final Map<String, _ExtractedRideAttendee> extractedRideAttendees = {};
    Set<String>? extractedExcludedTermsFilter;

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i].trim();

      if (i == 0) {
        if (!_isValidDatabaseVersion(line)) {
          break;
        }

        continue;
      }

      try {
        final Map<String, Object?> parsedLine = jsonDecode(line) as Map<String, Object?>;

        // Deleted lines are marked as deleted explicitly with a 'deleted' key set to true.
        if (parsedLine case {'deleted': true, 'store': final String store, 'key': final String key}) {
          switch (store) {
            case 'ride':
              extractedRides.remove(key);
            case 'member':
              extractedRiders.remove(key);
            case 'device':
              extractedDevices.remove(key);
            case 'rideAttendee':
              extractedRideAttendees.remove(key);
          }

          continue;
        }

        if (parsedLine case {
          'store': 'ride',
          'key': final String timestamp,
          'value': {'scannedAttendees': final num? scannedAttendees},
        }) {
          if (scannedAttendees != null && (!scannedAttendees.isFinite || scannedAttendees < 0)) {
            continue;
          }

          final DateTime? date = DateTime.tryParse(timestamp);

          if (date == null) {
            continue;
          }

          extractedRides[timestamp] = _ExtractedRide(date: date, scannedAttendees: scannedAttendees?.toInt());

          continue;
        }

        if (parsedLine case {
          'store': 'member',
          'key': final String uuid,
          'value': {
            'active': final bool? active,
            'alias': final String? alias,
            'firstname': final String firstName,
            'lastname': final String lastName,
            'profile': final String? profileImage,
          },
        }) {
          extractedRiders[uuid] = _ExtractedRider(
            active: active ?? true,
            alias: alias ?? '',
            firstName: firstName,
            lastName: lastName,
            profileImage: profileImage != null ? Uri.tryParse(profileImage) : null,
            uuid: uuid,
          );

          continue;
        }

        if (parsedLine case {
          'store': 'device',
          'key': final String deviceKey,
          'value': {'deviceName': final String deviceName, 'owner': final String ownerUuid, 'type': final num? type},
        }) {
          final int? typeIndex = type?.toInt();

          extractedDevices[deviceKey] = _ExtractedDevice(
            name: deviceName,
            ownerId: ownerUuid,
            type: typeIndex != null && typeIndex >= 0 && typeIndex < DeviceType.values.length
                ? DeviceType.values[typeIndex]
                : .unknown,
          );

          continue;
        }

        if (parsedLine case {
          'store': 'rideAttendee',
          // The key is the ride date, as ISO string followed by the UUID of the attendee.
          'key': final String attendeeKey,
          'value': {
            'attendee': final String attendeeUuid,
            'date': final String rideDate,
            'isScanned': final bool? isScanned,
          },
        }) {
          extractedRideAttendees[attendeeKey] = _ExtractedRideAttendee(
            isScanned: isScanned ?? true,
            rideDate: DateTime.parse(rideDate),
            uuid: attendeeUuid,
          );

          continue;
        }

        if (parsedLine case {
          'store': 'settings',
          'key': 'APPLICATION_SETTINGS',
          'value': {'excludedTermsFilter': final List<Object?>? value},
        }) {
          extractedExcludedTermsFilter = value?.whereType<String>().toSet() ?? {};
        }
      } catch (_) {
        // Skip invalid entries.
      }
    }

    return _ExtractedData(
      rides: extractedRides,
      riders: extractedRiders,
      devices: extractedDevices,
      rideAttendees: extractedRideAttendees,
      excludedTermsFilter: {...?extractedExcludedTermsFilter, ...sharedPreferencesExcludedTermsFilter}
          .map((term) => term.trim())
          .where((term) => term.isNotEmpty && term.length <= ExcludedTerms.termLength.max)
          .toSet(),
    );
  }
}

final class _ExtractedData {
  new({
    required this.rides,
    required this.riders,
    required this.devices,
    required this.rideAttendees,
    required this.excludedTermsFilter,
  });

  final Map<String, _ExtractedRide> rides;
  final Map<String, _ExtractedRider> riders;
  final Map<String, _ExtractedDevice> devices;
  final Map<String, _ExtractedRideAttendee> rideAttendees;
  final Set<String> excludedTermsFilter;
}

final class _ExtractedDevice {
  new({required this.name, required this.ownerId, required this.type});

  /// The human-readable name of the device.
  final String name;

  /// The UUID of the owner of this device.
  final String ownerId;

  /// The type of this device.
  final DeviceType type;
}

final class _ExtractedRide {
  new({required this.date, required this.scannedAttendees});

  /// The date on which this ride occurs in the calendar.
  final DateTime date;

  /// The amount of attendees that were automatically scanned for this ride.
  ///
  /// This variable is purely used for statistics and is not exported.
  final int? scannedAttendees;
}

final class _ExtractedRideAttendee {
  new({required this.isScanned, required this.rideDate, required this.uuid});

  /// Whether the attendee was scanned.
  ///
  /// If this is false, the attendee was manually selected.
  final bool isScanned;

  /// The date of the ride that belongs to this record.
  final DateTime rideDate;

  /// The UUID of the attendee that belongs to this record.
  final String uuid;
}

final class _ExtractedRider {
  new({
    required this.active,
    required this.alias,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.uuid,
  });

  /// Whether this rider is currently an active ride participant.
  final bool active;

  /// The rider's alias.
  final String? alias;

  /// The rider's first name.
  final String firstName;

  /// The rider's last name.
  final String lastName;

  /// The [Uri] to the rider's profile image.
  final Uri? profileImage;

  /// The rider's UUID.
  final String uuid;
}
