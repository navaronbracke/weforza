import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/ride_attendee_scanning/bluetooth_peripheral_with_owners.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate_state_machine.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/native_service/bluetooth_adapter.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/repository/rider_repository.dart';

/// This class represents the delegate
/// that manages the attendants for a given ride.
class RideAttendeeScanningDelegate {
  RideAttendeeScanningDelegate({
    required this.deviceRepository,
    required this.riderRepository,
    required this.onDeviceFound,
    required this.ride,
    required this.rideRepository,
    required this.settings,
  }) : scanner = BluetoothAdapter();

  /// The repository that loads all the devices.
  final DeviceRepository deviceRepository;

  /// The repository that loads the active riders.
  final RiderRepository riderRepository;

  /// The handler that is called
  /// when the delegate found a new `device` scan result.
  final void Function(BluetoothPeripheral device) onDeviceFound;

  /// The ride for which this delegate will scan attendants.
  final Ride ride;

  /// The repository that gets the attendees of [ride]
  /// and saves the ride attendees after a scan.
  final RideRepository rideRepository;

  /// The scanner that manages the Bluetooth state and running scan.
  final BluetoothDeviceScanner scanner;

  /// The settings for the delegate.
  final Settings settings;

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

  /// The controller that manages the attendees for [ride].
  final _rideAttendeeController = BehaviorSubject<Set<ScannedRideAttendee>>();

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

  /// Get the amount of selected ride attendees.
  int get attendeeCount => _rideAttendeeController.value.length;

  /// Get a stream of changes to the amount of selected ride attendees.
  Stream<int> get attendeeCountStream {
    return _rideAttendeeController.map((value) => value.length);
  }

  /// Get the current state of the state machine.
  RideAttendeeScanningState get currentState => _stateMachine.currentState;

  /// Returns whether there are active riders.
  bool get hasActiveRiders => _activeRiders.isNotEmpty;

  /// Whether this delegate has been disposed.
  bool get isDisposed => _stateMachine.isClosed;

  /// Get the stream of state changes for the scan process.
  Stream<RideAttendeeScanningState> get stream => _stateMachine.stateStream;

  /// Add the given [uuid] as a new ride attendee.
  ///
  /// The [isScanned] parameter indicates if this ride attendee
  /// was found automatically, or if it was manually added.
  void _addRideAttendee(String uuid, {required bool isScanned}) {
    if (_rideAttendeeController.isClosed) {
      return;
    }

    final items = _rideAttendeeController.value;

    items.add(ScannedRideAttendee(uuid: uuid, isScanned: isScanned));

    _rideAttendeeController.add(items);
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

    final excludedTerms = settings.excludedTermsFilter;

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
    return !_rideAttendeeController.value.contains(ScannedRideAttendee(uuid: owners.first, isScanned: false));
  }

  /// Load the active riders and their devices.
  Future<void> _loadActiveRidersWithDevices() async {
    final activeRiders = await riderRepository.getRiders(RiderFilterOption.active);

    for (final activeRider in activeRiders) {
      _activeRiders[activeRider.uuid] = activeRider;
    }

    final devices = await deviceRepository.getAllDevices();

    // Keep the devices that are owned by active riders.
    devices.retainWhere((device) => _activeRiders[device.ownerId] != null);

    // Collect the possible owners of each device.
    for (final device in devices) {
      if (_deviceOwners.containsKey(device.name)) {
        _deviceOwners[device.name]!.add(device.ownerId);
      } else {
        _deviceOwners[device.name] = <String>{device.ownerId};
      }
    }
  }

  /// Get the attendees of the [ride].
  Future<void> _loadRideAttendees() async {
    final items = await rideRepository.getScanResults(ride.date);

    if (_rideAttendeeController.isClosed) {
      return;
    }

    _rideAttendeeController.add(Set.of(items));
  }

  /// Prepare the scan by retrieving the existing ride attendees of [ride]
  /// and all the known devices, mapped to their owners.
  ///
  /// The former is used to detect whether a person is already an attendant.
  /// The latter is used to map incoming device scan results to one or more owners.
  Future<void> _prepareScan() {
    return Future.wait([_loadRideAttendees(), _loadActiveRidersWithDevices()]);
  }

  /// Remove [item] from the selection of ride attendees.
  void _removeRideAttendee(ScannedRideAttendee item) {
    if (_rideAttendeeController.isClosed) {
      return;
    }

    final currentSelection = _rideAttendeeController.value;

    currentSelection.remove(item);
    _rideAttendeeController.add(currentSelection);
  }

  /// Resolve the list of possible owners for the given [device] and add the device to the list of found devices.
  ///
  /// If the device has one owner, its owner is added to the list of scanned ride attendees.
  /// If the device has multiple possible owners,
  /// the list of possible owners for [device] is added to the list of unresolved device owners.
  void _resolvePossibleOwnersForDeviceAndAddDeviceToFoundDevicesList(BluetoothPeripheral device) {
    if (_stateMachine.isClosed) {
      return;
    }

    // Trim any excess spacing around the name, to allow for more flexible matching.
    final deviceName = device.deviceName.trim();

    // Get the owners of the device.
    final owners = _deviceOwners[deviceName]?.map((uuid) => _activeRiders[uuid]!) ?? [];

    // The device is a known device that has one or more possible owners.
    if (owners.isNotEmpty) {
      if (owners.length > 1) {
        // If the device has multiple possible owners,
        // add the conflicting owners to the unresolved owners.
        _unresolvedOwners.addAll(owners);
      } else {
        // Otherwise the single owner can be resolved automatically.
        _addRideAttendee(owners.first.uuid, isScanned: true);
      }
    }

    // Finally, add the device to the list of found devices and emit the device found signal.
    _devicesWithOwners.insert(0, BluetoothPeripheralWithOwners(device, owners.toList()));
    onDeviceFound(device);
  }

  /// Go to the manual selection screen.
  void continueToManualSelection() {
    _stateMachine.setState(RideAttendeeScanningState.manualSelection);
  }

  /// Get the amount of scanned peripherals.
  int get scannedPeripheralsLength => _devicesWithOwners.length;

  /// Get the scanned Bluetooth peripheral at the given [index].
  BluetoothPeripheralWithOwners getScannedPeripheral(int index) => _devicesWithOwners[index];

  /// Get the selected ride attendee for the rider with the given [uuid].
  ///
  /// Returns the selected ride attendee
  /// or null if the rider is currently not selected.
  ScannedRideAttendee? getSelectedRideAttendee(String uuid) {
    // Lookup if an attendee with the given uuid is selected.
    // The isScanned value is irrelevant, as it is merely presentational.
    return _rideAttendeeController.value.lookup(ScannedRideAttendee(uuid: uuid, isScanned: false));
  }

  /// Get the list of unresolved device owners
  /// that have not yet been scanned automatically.
  List<Rider> getUnresolvedDeviceOwners() {
    final rideAttendees = _rideAttendeeController.value;

    return _unresolvedOwners.where((Rider rider) {
      return !rideAttendees.contains(ScannedRideAttendee(uuid: rider.uuid, isScanned: false));
    }).toList();
  }

  /// Stop a running scan and switch to the next state in the scanning process.
  ///
  /// The [isScanning] parameter indicates if a scan is in progress.
  void maybeSkipScan({required bool isScanning}) async {
    // Try to stop the running scan first.
    if (isScanning && !await stopScan()) {
      return;
    }

    final newState =
        _unresolvedOwners.isEmpty
            ? RideAttendeeScanningState.manualSelection
            : RideAttendeeScanningState.unresolvedOwnersSelection;

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

      for (final item in _rideAttendeeController.value) {
        if (item.isScanned) {
          scannedAttendees++;
        }

        rideAttendees.add(RideAttendee(rideDate: ride.date, uuid: item.uuid, isScanned: item.isScanned));
      }

      final updatedRide = ride.copyWith(scannedAttendees: scannedAttendees);

      await rideRepository.updateRide(updatedRide, rideAttendees);

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
  void startDeviceScan() async {
    try {
      final hasPermission = await scanner.requestBluetoothScanPermission();

      if (!hasPermission) {
        _stateMachine.setState(RideAttendeeScanningState.permissionDenied);

        return;
      }

      // Bluetooth not being available is the same as it being off.
      final bluetoothIsOn = await scanner.bluetoothIsOn.catchError((_) => false);

      if (!bluetoothIsOn) {
        _stateMachine.setState(RideAttendeeScanningState.bluetoothDisabled);

        return;
      }

      _stateMachine.setState(RideAttendeeScanningState.startingScan);

      await _prepareScan();

      _stateMachine.setState(RideAttendeeScanningState.scanning);

      _scanSubscription = scanner
          .scanForDevices(settings.scanDuration)
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

    _stateMachine.setState(RideAttendeeScanningState.stoppingScan);

    try {
      // Stop the scan first.
      await scanner.stopScan();

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
    if (!_rideAttendeeController.value.contains(item)) {
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
    final currentSelection = _rideAttendeeController.value;

    if (currentSelection.contains(item)) {
      _removeRideAttendee(item);
    } else {
      _addRideAttendee(item.uuid, isScanned: false);
    }
  }

  /// Dispose of this delegate.
  Future<void> dispose() async {
    if (_stateMachine.isClosed) {
      return;
    }

    await _stateMachine.dispose();
    await scanner.dispose();
    await _rideAttendeeController.close();
    await _scanSubscription?.cancel();
    _scanSubscription = null;
  }
}
