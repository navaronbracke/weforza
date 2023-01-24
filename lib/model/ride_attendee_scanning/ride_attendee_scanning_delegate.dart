import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate_state_machine.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_device.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/repository/ride_repository.dart';

/// This class represents the delegate
/// that manages the attendants for a given ride.
class RideAttendeeScanningDelegate {
  RideAttendeeScanningDelegate({
    required this.deviceRepository,
    required this.memberRepository,
    required this.onDeviceFound,
    required this.ride,
    required this.rideRepository,
    required this.scanner,
    required this.settings,
    required TickerProvider vsync,
  }) : _scanProgressBarController = AnimationController(
          duration: Duration(seconds: settings.scanDuration),
          vsync: vsync,
          value: 1.0,
        ) {
    _startScanningSubscription = scanner.isScanning.listen(_listenToScanStart);
  }

  /// The repository that loads all the devices.
  final DeviceRepository deviceRepository;

  /// The repository that loads the active members.
  final MemberRepository memberRepository;

  /// The handler that is called
  /// when the delegate found a new `device` scan result.
  final void Function(BluetoothPeripheral device) onDeviceFound;

  /// The ride for which this delegate will scan attendants.
  final Ride ride;

  /// The repository that gets the attendees of [ride]
  /// and saves the ride attendees after a scan.
  final RideRepository rideRepository;

  /// The scanner that manages the bluetooth state and running scan.
  final BluetoothDeviceScanner scanner;

  /// The settings for the delegate.
  final Settings settings;

  /// This map contains all the active members mapped to their [Member.uuid].
  final _activeMembers = <String, Member>{};

  /// This map contains the uuids of owners per device name.
  ///
  /// The keys are device names.
  /// The values are the uuids of the active members,
  /// that own a device with the [MapEntry.key] as device name.
  final _deviceOwners = <String, Set<String>>{};

  /// The controller that manages the attendees for [ride].
  final _rideAttendeeController = BehaviorSubject<Set<ScannedRideAttendee>>();

  /// This list contains the devices that were scanned.
  final _scannedDevices = <ScannedDevice>[];

  /// The controller for the scanning progress bar.
  final AnimationController _scanProgressBarController;

  /// This flag is a mutex that locks the ride attendee selection
  /// when the selection is being saved.
  /// When this flag is true, the selection should not be modified.
  bool _selectionLocked = false;

  /// The subscription that listens to the start of the Bluetooth scan.
  StreamSubscription<bool>? _startScanningSubscription;

  /// The state machine for the scanning page.
  final _stateMachine = RideAttendeeScanningDelegateStateMachine();

  /// The scroll controller for the scanning page stepper.
  final _stepperScrollController = ScrollController();

  /// This set will contain all the owners
  /// that could not be resolved automatically.
  ///
  /// An owner cannot be resolved automatically
  /// if a scanned device has two or more possible owners,
  /// because then there are multiple valid options.
  final _unresolvedOwners = <Member>{};

  /// Get the list of active members.
  List<Member> get activeMembers => _activeMembers.values.toList();

  /// Get the amount of selected ride attendees.
  int get attendeeCount => _rideAttendeeController.value.length;

  /// Get a stream of changes to the amount of selected ride attendees.
  Stream<int> get attendeeCountStream {
    return _rideAttendeeController.map((value) => value.length);
  }

  /// Get the current state of the state machine.
  RideAttendeeScanningState get currentState => _stateMachine.currentState;

  /// Returns whether there are active members.
  bool get hasActiveMembers => _activeMembers.isNotEmpty;

  /// Get the controller for the scan progress bar.
  AnimationController get progressBarController => _scanProgressBarController;

  /// Get the scroll controller for the scan stepper.
  ScrollController get stepperScrollController => _stepperScrollController;

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

  /// Add [device] to the list of scanned devices.
  void _addScannedDevice(BluetoothPeripheral device) {
    if (_stateMachine.isClosed) {
      return;
    }

    final deviceName = device.deviceName;

    // Get the owners of the device.
    final owners = _deviceOwners[deviceName]?.map(
      (uuid) => _activeMembers[uuid]!,
    );

    // The device is a known device that has one or more possible owners.
    if (owners != null && owners.isNotEmpty) {
      if (owners.length > 1) {
        // If the device has multiple possible owners,
        // add the conflicting owners to the unresolved owners.
        _unresolvedOwners.addAll(owners);
      } else {
        // Otherwise the single owner can be resolved automatically.
        _addRideAttendee(owners.first.uuid, isScanned: true);
      }
    }

    _scannedDevices.insert(0, ScannedDevice(deviceName, [...?owners]));

    onDeviceFound(device);
  }

  /// Check whether a given [BluetoothPeripheral.deviceName]
  /// should be accepted as a scan result.
  ///
  /// Returns false for device names that are empty,
  /// or consist only of whitespace.
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
    final deviceName = device.deviceName;

    if (deviceName.trim().isEmpty) {
      return false;
    }

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
    return !_rideAttendeeController.value.contains(
      ScannedRideAttendee(uuid: owners.first, isScanned: false),
    );
  }

  /// Listen to the start signal of the Bluetooth scan
  /// and start decreasing the progress in the progress bar.
  void _listenToScanStart(bool isScanning) {
    if (_stateMachine.isClosed || !isScanning) {
      return;
    }

    // Start decreasing the progress when the scan starts.
    if (_scanProgressBarController.status == AnimationStatus.completed) {
      _scanProgressBarController.reverse();
    }
  }

  /// Load the active members and their devices.
  Future<void> _loadActiveMembersWithDevices() async {
    final activeMembers = await memberRepository.getMembers(
      MemberFilterOption.active,
    );

    for (final activeMember in activeMembers) {
      _activeMembers[activeMember.uuid] = activeMember;
    }

    final devices = await deviceRepository.getAllDevices();

    // Keep the devices that are owned by active members.
    devices.retainWhere((device) => _activeMembers[device.ownerId] != null);

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
    return Future.wait([_loadRideAttendees(), _loadActiveMembersWithDevices()]);
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

  /// Request permission to check the bluetooth adapter state and
  /// start a bluetooth peripheral scan.
  ///
  /// Returns wether or not the permissions were granted.
  Future<bool> _requestScanPermission() async {
    final permissions = <Permission>[];

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      final androidVersion = androidInfo.version.sdkInt;

      // Android <12 uses the legacy permissions.
      if (androidVersion < 31) {
        permissions.addAll([
          // Without the location, the scan does not find devices.
          Permission.locationWhenInUse,
          Permission.bluetooth,
        ]);
      } else {
        // Android 12+ uses the newer Bluetooth permissions.
        permissions.add(Permission.bluetoothScan);
      }
    } else if (Platform.isIOS) {
      // iOS 13+ needs Bluetooth permission.
      // On lower versions this permission is always granted,
      // since it does not exist.
      // The permission plugin handles this internally,
      // so there is no need to check the version.
      permissions.add(Permission.bluetooth);
    } else {
      throw UnsupportedError('Only Android and iOS are supported');
    }

    final statuses = await permissions.request();

    for (final status in statuses.values) {
      if (status != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  /// Scroll the manual selection label into view.
  void _scrollToManualSelectionLabel() {
    if (_stepperScrollController.hasClients) {
      _stepperScrollController.animateTo(
        _stepperScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  /// Go to the manual selection screen.
  void continueToManualSelection() {
    _stateMachine.setState(RideAttendeeScanningState.manualSelection);
    _scrollToManualSelectionLabel();
  }

  /// Get the scanned device at the given [index].
  ScannedDevice getScannedDevice(int index) => _scannedDevices[index];

  /// Get the selected ride attendee for the member with the given [uuid].
  ///
  /// Returns the selected ride attendee
  /// or null if the member is currently not selected.
  ScannedRideAttendee? getSelectedRideAttendee(String uuid) {
    // Lookup if an attendee with the given uuid is selected.
    // The isScanned value is irrelevant, as it is merely presentational.
    return _rideAttendeeController.value.lookup(
      ScannedRideAttendee(uuid: uuid, isScanned: false),
    );
  }

  /// Get the list of unresolved device owners
  /// that have not yet been scanned automatically.
  List<Member> getUnresolvedDeviceOwners() {
    final rideAttendees = _rideAttendeeController.value;

    return _unresolvedOwners.where((Member member) {
      return !rideAttendees.contains(
        ScannedRideAttendee(uuid: member.uuid, isScanned: false),
      );
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

    final newState = _unresolvedOwners.isEmpty
        ? RideAttendeeScanningState.manualSelection
        : RideAttendeeScanningState.unresolvedOwnersSelection;

    _stateMachine.setState(newState);

    if (newState == RideAttendeeScanningState.manualSelection) {
      _scrollToManualSelectionLabel();
    }
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

        rideAttendees.add(
          RideAttendee(
            rideDate: ride.date,
            uuid: item.uuid,
            isScanned: item.isScanned,
          ),
        );
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
      final hasPermission = await _requestScanPermission();

      if (!hasPermission) {
        _stateMachine.setState(RideAttendeeScanningState.permissionDenied);

        return;
      }

      final bluetoothEnabled = await scanner.isBluetoothEnabled();

      if (!bluetoothEnabled) {
        _stateMachine.setState(RideAttendeeScanningState.bluetoothDisabled);

        return;
      }

      _stateMachine.setState(RideAttendeeScanningState.startingScan);

      await _prepareScan();

      _stateMachine.setState(RideAttendeeScanningState.scanning);

      scanner
          .scanForDevices(settings.scanDuration)
          .where(_includeScanResult)
          .listen(
        _addScannedDevice,
        onError: (error) {
          // Ignore errors from individual events.
          // Otherwise the next scan results might be dropped.
        },
        // Don't stop scanning even if an event was an error.
        cancelOnError: false,
      );
    } catch (error) {
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
      await scanner.stopScan();

      return true;
    } catch (error) {
      _stateMachine.setStopScanError();

      return false;
    }
  }

  /// Toggle the selection state for the given active member.
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
  Future<bool> toggleSelectionForActiveMember(
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
  void dispose() {
    _stateMachine.dispose();
    _rideAttendeeController.close();
    scanner.dispose();
    _startScanningSubscription?.cancel();
    _startScanningSubscription = null;
    _scanProgressBarController.dispose();
    _stepperScrollController.dispose();
  }
}
