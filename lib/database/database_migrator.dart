/// @docImport 'package:weforza/database/sembast/database_tables.dart';
library;

import 'dart:convert' show jsonDecode;

import 'package:file/file.dart';
import 'package:file/local.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weforza/model/device/device_type.dart';

/// This class migrates the old database format to the new Drift format.
///
/// The old database is a text file, with each line being a JSON object.
///
/// The first line is the version specifier, i.e. `{"version":1,"sembast":1}`
/// Subsequent lines are individual records, as individual JSON objects.
///
/// Each record line has a `key`, corresponding to the key of the record.
/// See [DatabaseTables], which defines that each key is a [String], per `stringMapStoreFactory`.
///
/// For example `{"key":"2026-10-17T00:00:00.000","store":"ride","value":{"scannedAttendees":null}}`
final class DatabaseMigrator {
  DatabaseMigrator({
    this._fileSystem = const LocalFileSystem(),
    this._getDatabaseDirectory = _getApplicationSupportDirectory,
  });

  /// The name of the old database file.
  static const String oldDatabaseName = 'weforza_database.db';

  /// The name of the settings key for the scan excluded terms filter in the settings record or shared preferences.
  static const String scanExcludedTermsFilterKey = 'scanExcludedTermsFilter';

  /// The file system used to access the database file.
  final FileSystem _fileSystem;

  /// The function that provides the directory where the database file is stored.
  final Future<Directory> Function(FileSystem fileSystem) _getDatabaseDirectory;

  /// Get the application support directory, using the given [fileSystem].
  static Future<Directory> _getApplicationSupportDirectory(FileSystem fileSystem) {
    return getApplicationSupportDirectory().then((directory) => fileSystem.directory(directory.path));
  }

  /// Read the old database file and return its contents as a list of lines.
  Future<List<String>> _readOldDatabase() async {
    final Directory oldDatabaseDir = await _getDatabaseDirectory(_fileSystem);
    final File oldDatabaseFile = _fileSystem.file(join(oldDatabaseDir.path, oldDatabaseName));

    if (!oldDatabaseFile.existsSync()) {
      return [];
    }

    return oldDatabaseFile.readAsLines();
  }

  Future<void> migrate() async {
    final prefs = SharedPreferencesAsync();
    final List<String> oldDatabaseLines = await _readOldDatabase();

    // Pop the excluded terms list from shared preferences, these will be moved to the new database.
    final List<String>? sharedPreferencesExcludedTermsFilter = await prefs.getStringList(scanExcludedTermsFilterKey);
    if (sharedPreferencesExcludedTermsFilter != null) {
      await prefs.remove(scanExcludedTermsFilterKey);
    }

    final _ExtractedData extractedData = _parseDatabaseLines(
      oldDatabaseLines,
      sharedPreferencesExcludedTermsFilter: sharedPreferencesExcludedTermsFilter ?? const [],
    );

    // TODO: write records to DB
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
    final List<_ExtractedRide> extractedRides = [];
    final List<_ExtractedRider> extractedRiders = [];
    final List<_ExtractedDevice> extractedDevices = [];
    final List<_ExtractedRideAttendee> extractedRideAttendees = [];
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
        if (parsedLine['deleted'] == true) {
          continue;
        }

        if (parsedLine case {
          'store': 'ride',
          'key': final String timestamp,
          'value': {'scannedAttendees': final num? scannedAttendees},
        }) {
          extractedRides.add(
            _ExtractedRide(date: DateTime.parse(timestamp), scannedAttendees: scannedAttendees?.toInt()),
          );

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
            'lastUpdated': final String lastUpdated,
            'profile': final String? profileImage,
          },
        }) {
          extractedRiders.add(
            _ExtractedRider(
              active: active ?? true,
              alias: alias ?? '',
              firstName: firstName,
              lastName: lastName,
              lastUpdated: DateTime.parse(lastUpdated),
              profileImage: profileImage != null ? Uri.tryParse(profileImage) : null,
              uuid: uuid,
            ),
          );

          continue;
        }

        if (parsedLine case {
          'store': 'device',
          'key': final String creationTimestamp,
          'value': {'deviceName': final String deviceName, 'owner': final String ownerUuid, 'type': final num? type},
        }) {
          final int? typeIndex = type?.toInt();

          extractedDevices.add(
            _ExtractedDevice(
              creationDate: DateTime.parse(creationTimestamp),
              name: deviceName,
              ownerId: ownerUuid,
              type: typeIndex != null && typeIndex >= 0 && typeIndex < DeviceType.values.length
                  ? DeviceType.values[typeIndex]
                  : .unknown,
            ),
          );
        }

        if (parsedLine case {
          'store': 'rideAttendee',
          // The key is the ride date, as ISO string followed by the UUID of the attendee.
          'key': final String _,
          'value': {
            'attendee': final String attendeeUuid,
            'date': final String rideDate,
            'isScanned': final bool? isScanned,
          },
        }) {
          extractedRideAttendees.add(
            _ExtractedRideAttendee(
              isScanned: isScanned ?? true,
              rideDate: DateTime.parse(rideDate),
              uuid: attendeeUuid,
            ),
          );
        }

        if (parsedLine case {
          'store': 'settings',
          'key': 'APPLICATION_SETTINGS',
          'value': {'excludedTermsFilter': final List<Object?>? value},
        }) {
          extractedExcludedTermsFilter = value?.whereType<String>().toSet() ?? {};
        }
      } on FormatException {
        // Skip invalid entries.
      }
    }

    return _ExtractedData(
      rides: extractedRides,
      riders: extractedRiders,
      devices: extractedDevices,
      rideAttendees: extractedRideAttendees,
      excludedTermsFilter: extractedExcludedTermsFilter ?? {},
    );
  }
}

final class _ExtractedData {
  _ExtractedData({
    required this.rides,
    required this.riders,
    required this.devices,
    required this.rideAttendees,
    required this.excludedTermsFilter,
  });

  final List<_ExtractedRide> rides;
  final List<_ExtractedRider> riders;
  final List<_ExtractedDevice> devices;
  final List<_ExtractedRideAttendee> rideAttendees;
  final Set<String> excludedTermsFilter;
}

final class _ExtractedDevice {
  _ExtractedDevice({required this.creationDate, required this.name, required this.ownerId, required this.type});

  /// The creation date of this device.
  /// This creation date is not indicative of the actual creation date
  /// of the physical hardware item.
  /// It is only used internally as the key for the device record.
  final DateTime creationDate;

  /// The human-readable name of the device.
  final String name;

  /// The UUID of the owner of this device.
  final String ownerId;

  /// The type of this device.
  final DeviceType type;
}

final class _ExtractedRide {
  _ExtractedRide({required this.date, required this.scannedAttendees});

  /// The date on which this ride occurs in the calendar.
  final DateTime date;

  /// The amount of attendees that were automatically scanned for this ride.
  ///
  /// This variable is purely used for statistics and is not exported.
  final int? scannedAttendees;
}

final class _ExtractedRideAttendee {
  _ExtractedRideAttendee({required this.isScanned, required this.rideDate, required this.uuid});

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
  _ExtractedRider({
    required this.active,
    required this.alias,
    required this.firstName,
    required this.lastName,
    required this.lastUpdated,
    required this.profileImage,
    required this.uuid,
  });

  /// Whether this rider is currently an active ride participant.
  final bool active;

  /// The rider's alias.
  final String alias;

  /// The rider's first name.
  final String firstName;

  /// The rider's last name.
  final String lastName;

  /// The last time that this rider was updated.
  final DateTime lastUpdated;

  /// The [Uri] to the rider's profile image.
  final Uri? profileImage;

  /// The rider's UUID.
  final String uuid;
}
