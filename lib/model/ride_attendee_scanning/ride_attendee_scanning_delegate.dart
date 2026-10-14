/// @docImport 'package:weforza/model/device/device.dart';
library;

import 'dart:async';

import 'package:flutter/foundation.dart' show ValueNotifier, ValueListenable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/ride_attendee_scanning/bluetooth_peripheral_with_owners.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate_state_machine.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/native_service/bluetooth_adapter.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

/// This class represents the delegate
/// that manages the attendants for a given ride.
class RideAttendeeScanningDelegate {
  RideAttendeeScanningDelegate({
    required this._deviceRepository,
    required this._onDeviceFound,
    required this._ride,
    required this._rideRepository,
    required this._riderRepository,
    required this._settings,
  }) : _scanner = BluetoothAdapter();

  /// The repository that loads all the devices.
  final DeviceRepository _deviceRepository;

  /// The handler that is called when the delegate found a new [Device] scan result.
  final void Function(BluetoothPeripheral device) _onDeviceFound;

  /// The ride for which this delegate will scan attendants.
  final Ride _ride;

  /// The repository that gets the attendees of the given [Ride]
  /// and saves the ride attendees after a scan.
  final RideRepository _rideRepository;

  /// The repository that loads the active riders.
  final RiderRepository _riderRepository;

  /// The scanner that manages the Bluetooth state and running scan.
  final BluetoothDeviceScanner _scanner;

  /// The settings for the delegate.
  final Settings _settings;

  /// This map contains all the active riders mapped to their [Rider.uuid].
  final _activeRiders = <String, Rider>{};

  /// This map contains the uuids of owners per device name.
  ///
  /// The keys are device names.
  /// The values are the uuids of the active riders,
  /// that own a device with the [MapEntry.key] as device name.
  final _deviceOwners = <String, Set<String>>{};

  /// The list of Bluetooth peripherals with possible owners per peripheral.
  final _devicesWithOwners = <BluetoothPeripheralWithOwners>[];

  /// The notifier that manages the attendees for the given [Ride].
  final _rideAttendeeNotifier = ValueNotifier<Set<ScannedRideAttendee>>({});

  /// The set of scanned Bluetooth peripherals.
  final Set<BluetoothPeripheral> _scannedDevices = {};

  /// This flag is a mutex that locks the ride attendee selection
  /// when the selection is being saved.
  /// When this flag is true, the selection should not be modified.
  bool _selectionLocked = false;

  /// The subscription for the scan results.
  StreamSubscription<Object?>? _scanSubscription;

  /// The state machine for the scanning page.
  final _stateMachine = RideAttendeeScanningDelegateStateMachine();

  /// This set will contain all the owners
  /// that could not be resolved automatically.
  ///
  /// An owner cannot be resolved automatically
  /// if a scanned device has two or more possible owners,
  /// because then there are multiple valid options.
  final _unresolvedOwners = <Rider>{};

  /// Get the list of active riders.
  List<Rider> get activeRiders => _activeRiders.values.toList();

  /// Get a [ValueListenable] for the set of selected [RideAttendee]s.
  ValueListenable<Set<RideAttendee>> get attendeesListenable => _rideAttendeeNotifier;

  /// Returns whether there are active riders.
  bool get hasActiveRiders => _activeRiders.isNotEmpty;

  /// Whether this delegate has been disposed.
  bool get isDisposed => _stateMachine.isDisposed;

  /// Get the amount of scanned devices.
  int get scannedDevicesLength => _devicesWithOwners.length;

  /// Get a [ValueListenable] for the scanning state of the ride attendee scanning process.
  ValueListenable<AsyncValue<RideAttendeeScanningState>> get scanningStateListenable => _stateMachine.listenable;

  /// Add the given [uuid] as a new ride attendee.
  ///
  /// The [isScanned] parameter indicates if this ride attendee
  /// was found automatically, or if it was manually added.
  void _addRideAttendee(String uuid, {required bool isScanned}) {
    final items = _rideAttendeeNotifier.value;

    items.add(ScannedRideAttendee(uuid: uuid, isScanned: isScanned));

    _rideAttendeeNotifier.value = items;
  }

  /// Check whether a given [BluetoothPeripheral] should be accepted as a scan result.
  ///
  /// Returns false for invalid devices,
  /// in other words devices with a [BluetoothPeripheral.deviceName] or [BluetoothPeripheral.id]
  /// that is empty or consist solely of whitespace.
  ///
  /// Returns false for devices that were already scanned before.
  ///
  /// Returns false for device names that contain any value of the
  /// [Settings.excludedTermsFilter] values.
  ///
  /// Returns true for unknown devices.
  ///
  /// Returns true for devices with multiple possible owners.
  ///
  /// Returns true for devices with a single owner,
  /// if said owner was not (yet) scanned during the currently running scan.
  ///
  /// Returns false for devices with a single owner,
  /// if said owner was already scanned during the currently running scan.
  bool _includeScanResult(BluetoothPeripheral device) {
    final deviceName = device.deviceName.trim();
    final deviceId = device.id.trim();

    // Discard invalid devices and devices that were already scanned.
    if (deviceId.isEmpty || deviceName.isEmpty || _scannedDevices.contains(device)) {
      return false;
    }

    _scannedDevices.add(device);

    final excludedTerms = _settings.excludedTermsFilter;

    if (excludedTerms.isNotEmpty) {
      for (final excludedTerm in excludedTerms) {
        if (deviceName.contains(excludedTerm)) {
          return false;
        }
      }
    }

    final owners = _deviceOwners[deviceName];

    // It's an unknown device, or a device with multiple possible owners.
    if (owners == null || owners.isEmpty || owners.length > 1) {
      return true;
    }

    // It's a device with exactly one owner.
    // Only include it if the owner wasn't scanned yet.
    // The value of `isScanned` is irrelevant,
    // since it is excluded from the `operator==` implementation.
    return !_rideAttendeeNotifier.value.contains(ScannedRideAttendee(uuid: owners.first, isScanned: false));
  }

  /// Load the active riders and their devices.
  Future<void> _loadActiveRidersWithDevices() async {
    final (activeRiders, devices) = await (_riderRepository.getRiders(.active), _deviceRepository.getAllDevices()).wait;

    if (isDisposed) {
      return;
    }

    for (final activeRider in activeRiders) {
      _activeRiders[activeRider.uuid] = activeRider;
    }

    // Keep the devices that are owned by active riders.
    devices.retainWhere((device) => _activeRiders[device.ownerId] != null);

    // Collect the possible owners of each device.
    for (final device in devices) {
      if (_deviceOwners.containsKey(device.name)) {
        _deviceOwners[device.name]?.add(device.ownerId);

        continue;
      }

      _deviceOwners[device.name] = <String>{device.ownerId};
    }
  }

  /// Get the attendees of the given [Ride].
  Future<void> _loadRideAttendees() async {
    final items = await _rideRepository.getScanResults(_ride.date);

    if (isDisposed) {
      return;
    }

    _rideAttendeeNotifier.value = Set.of(items);
  }

  /// Prepare the scan by retrieving the existing ride attendees of the given [Ride]
  /// and all the known devices, mapped to their owners.
  ///
  /// The former is used to detect whether a person is already an attendant.
  /// The latter is used to map incoming device scan results to one or more owners.
  Future<void> _prepareScan() {
    return Future.wait([_loadRideAttendees(), _loadActiveRidersWithDevices()]);
  }

  /// Remove [item] from the selection of ride attendees.
  void _removeRideAttendee(ScannedRideAttendee item) {
    if (isDisposed) {
      return;
    }

    final currentSelection = _rideAttendeeNotifier.value;

    currentSelection.remove(item);
    _rideAttendeeNotifier.value = currentSelection;
  }

  /// Resolve the list of possible owners for the given [device] and add the device to the list of found devices.
  ///
  /// If the device has one owner, its owner is added to the list of scanned ride attendees.
  /// If the device has multiple possible owners,
  /// the list of possible owners for [device] is added to the list of unresolved device owners.
  void _resolvePossibleOwnersForDeviceAndAddDeviceToFoundDevicesList(BluetoothPeripheral device) {
    if (isDisposed) {
      return;
    }

    // Trim any excess spacing around the name, to allow for more flexible matching.
    final deviceName = device.deviceName.trim();

    // Get the owners of the device.
    final owners = _deviceOwners[deviceName]?.map((uuid) => _activeRiders[uuid]!) ?? [];

    switch (owners.length) {
      case 1:
        // The single owner can be resolved automatically.
        _addRideAttendee(owners.first.uuid, isScanned: true);
      case > 1:
        // If the device has multiple possible owners,
        // add the conflicting owners to the unresolved owners.
        _unresolvedOwners.addAll(owners);
    }

    // Finally, add the device to the list of found devices and emit the device found signal.
    _devicesWithOwners.insert(0, BluetoothPeripheralWithOwners(device, owners.toList()));
    _onDeviceFound(device);
  }

  /// Go to the manual selection screen.
  void continueToManualSelection() => _stateMachine.setState(.manualSelection);

  /// Get the scanned Bluetooth peripheral at the given [index].
  BluetoothPeripheralWithOwners getScannedPeripheral(int index) => _devicesWithOwners[index];

  /// Get the selected ride attendee for the rider with the given [uuid].
  ///
  /// Returns the selected ride attendee
  /// or null if the rider is currently not selected.
  ScannedRideAttendee? getSelectedRideAttendee(String uuid) {
    // Lookup if an attendee with the given uuid is selected.
    // The isScanned value is irrelevant, as it is merely presentational.
    return _rideAttendeeNotifier.value.lookup(ScannedRideAttendee(uuid: uuid, isScanned: false));
  }

  /// Get the list of unresolved device owners
  /// that have not yet been scanned automatically.
  List<Rider> getUnresolvedDeviceOwners() {
    final rideAttendees = _rideAttendeeNotifier.value;

    return [
      for (final rider in _unresolvedOwners)
        if (!rideAttendees.contains(ScannedRideAttendee(uuid: rider.uuid, isScanned: false))) rider,
    ];
  }

  /// Stop a running scan and switch to the next state in the scanning process.
  ///
  /// The [isScanning] parameter indicates if a scan is in progress.
  Future<void> maybeSkipScan({required bool isScanning}) async {
    // Try to stop the running scan first.
    if (isScanning && !await stopScan()) {
      return;
    }

    final RideAttendeeScanningState newState = _unresolvedOwners.isEmpty
        ? .manualSelection
        : .unresolvedOwnersSelection;

    _stateMachine.setState(newState);
  }

  /// Save the current selection of ride attendees.
  ///
  /// Returns the updated ride.
  Future<Ride> saveRideAttendeeSelection() async {
    if (_selectionLocked) {
      throw StateError('Cannot save the selection when it is locked.');
    }

    _selectionLocked = true;

    try {
      int scannedAttendees = 0;
      final rideAttendees = <RideAttendee>[];

      for (final item in _rideAttendeeNotifier.value) {
        if (item.isScanned) {
          scannedAttendees++;
        }

        rideAttendees.add(RideAttendee(rideDate: _ride.date, uuid: item.uuid, isScanned: item.isScanned));
      }

      final updatedRide = _ride.copyWith(scannedAttendees: scannedAttendees);

      await _rideRepository.updateRide(updatedRide, rideAttendees);

      return updatedRide;
    } catch (error) {
      _stateMachine.setSaveScanResultsError();

      rethrow;
    } finally {
      _selectionLocked = false;
    }
  }

  /// Start a new device scan.
  ///
  /// This method requests the necessary permissions,
  /// performs setup for the scanner and starts a scan.
  Future<void> startDeviceScan() async {
    try {
      final hasPermission = await _scanner.requestBluetoothScanPermission();

      if (isDisposed) {
        return;
      }

      if (!hasPermission) {
        _stateMachine.setState(.permissionDenied);

        return;
      }

      // Bluetooth not being available is the same as it being off.
      final bluetoothIsOn = await _scanner.bluetoothIsOn.catchError((_) => false);

      if (isDisposed) {
        return;
      }

      if (!bluetoothIsOn) {
        _stateMachine.setState(.bluetoothDisabled);

        return;
      }

      _stateMachine.setState(.startingScan);

      await _prepareScan();

      if (isDisposed) {
        return;
      }

      _stateMachine.setState(.scanning);

      _scanSubscription = _scanner
          .scanForDevices(_settings.scanDuration)
          .where(_includeScanResult)
          .listen(
            _resolvePossibleOwnersForDeviceAndAddDeviceToFoundDevicesList,
            // Don't stop scanning even if an event was an error.
            cancelOnError: false,
            onError: (error) {
              // Ignore errors from individual events.
              // Otherwise the next scan results might be dropped.
            },
          );
    } catch (_) {
      _stateMachine.setStartScanError();
    }
  }

  /// Stop a running device scan.
  ///
  /// Returns whether the scan was stopped successfully.
  Future<bool> stopScan() async {
    // Return early if the scanner does not have to be stopped.
    if (!_stateMachine.shouldStopScanner) {
      return true;
    }

    _stateMachine.setState(.stoppingScan);

    try {
      // Stop the scan first.
      await _scanner.stopScan();

      if (isDisposed) {
        return true;
      }

      // Then cancel the subscription to clean up the event stream.
      await _scanSubscription?.cancel();
      _scanSubscription = null;

      return true;
    } catch (error) {
      _stateMachine.setStopScanError();

      return false;
    }
  }

  /// Toggle the selection state for the given active rider.
  ///
  /// If the [item] is selected and the item was manually added,
  /// it is removed from the selection.
  ///
  /// If the [item] is selected and the item was scanned automatically,
  /// a confirmation is requested using the [requestUnselectConfirmation]
  /// method. If the confirmation indicates that the item should be unselected,
  /// it is removed from the selection. Otherwise the selection is not modified.
  ///
  /// If the [item] was not selected,
  /// it is added to the selection as a manually selected item.
  ///
  /// If the selection is locked, the selection is also not modified.
  ///
  /// Returns whether the selection was updated.
  Future<bool> toggleSelectionForActiveRider(
    ScannedRideAttendee item,
    Future<bool> Function() requestUnselectConfirmation,
  ) async {
    if (_selectionLocked) {
      return false;
    }

    // The item is not yet in the selection.
    // Add it to the selection as a manually selected entry.
    if (!_rideAttendeeNotifier.value.contains(item)) {
      _addRideAttendee(item.uuid, isScanned: false);

      return true;
    }

    // The item is in the selection and the item was previously scanned.
    // Ask for confirmation before unselecting the item.
    if (item.isScanned) {
      final confirmation = await requestUnselectConfirmation();

      if (!confirmation) {
        return false;
      }
    }

    _removeRideAttendee(item);

    return true;
  }

  /// Toggle the selection state for the given unresolved owner.
  ///
  /// If the [item] was selected, it is removed from the selection.
  ///
  /// If the [item] was not selected,
  /// it is added to the selection as a manually selected item.
  void toggleSelectionForUnresolvedOwner(ScannedRideAttendee item) {
    final currentSelection = _rideAttendeeNotifier.value;

    if (currentSelection.contains(item)) {
      _removeRideAttendee(item);
    } else {
      _addRideAttendee(item.uuid, isScanned: false);
    }
  }

  /// Dispose of this delegate.
  Future<void> dispose() async {
    // The state machine drives the disposal state.
    if (isDisposed) {
      return;
    }

    _stateMachine.dispose();
    _rideAttendeeNotifier.dispose();
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    await _scanner.dispose();
  }
}
