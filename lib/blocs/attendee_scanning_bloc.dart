import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';

import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/ride_attendee.dart';
import 'package:weforza/model/ride_attendee_scan_result.dart';
import 'package:weforza/model/scan_process_step.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';

class AttendeeScanningBloc extends Bloc {
  AttendeeScanningBloc({
    required this.ride,
    required this.scanner,
    required this.settingsRepo,
    required this.memberRepo,
    required this.deviceRepo,
    required this.ridesRepo,
  });

  ///The bluetooth scanner that will do bluetooth stuff for us.
  final BluetoothDeviceScanner scanner;

  /// The already scanned devices are stored here.
  /// This prevents duplicates during the scan.
  final Set<BluetoothPeripheral> _scannedDevices = HashSet();

  final _scanningController = BehaviorSubject.seeded(false);
  final BehaviorSubject<int> _attendeeCountController = BehaviorSubject();

  /// The search query controller.
  final _queryController = BehaviorSubject.seeded('');

  /// The visibility controller for the scanned members.
  final _showScannedController = BehaviorSubject.seeded(true);

  void onQueryChanged(String newQuery) => _queryController.add;
  void onShowScannedChanged(bool newShowScanned) => _showScannedController.add;

  /// This controller maintains the general UI state as divided in steps by [ScanProcessStep].
  final _scanStepController = BehaviorSubject.seeded(ScanProcessStep.init);

  Stream<ScanProcessStep> get scanStepStream => _scanStepController.stream;
  Stream<bool> get scanning => _scanningController.stream;

  Stream<bool> get showScanned => _showScannedController.stream;
  Stream<String> get searchQuery => _queryController.stream;

  /// Every step before [ScanProcessStep.manual]
  /// should highlight the first step label.
  Stream<bool> get isScanStep => scanStepStream
      .map((currentStep) => currentStep != ScanProcessStep.manual);
  Stream<int> get attendeeCount => _attendeeCountController.stream;

  ///The repositories connect the bloc with the database.
  final SettingsRepository settingsRepo;
  final MemberRepository memberRepo;
  final DeviceRepository deviceRepo;
  final RideRepository ridesRepo;

  ///The ride that will get attendees assigned
  ///during the scan / manual assignment.
  final Ride ride;

  ///The scan future is stored here.
  ///During init state [doInitialDeviceScan] is stored here.
  ///When a user retries a scan, [retryDeviceScan] is stored here.
  ///This future is not used by a FutureBuilder since the UI is managed by a StreamBuilder.
  late Future<void> scanFuture;

  ///Store the ride attendees in a hash set for easy lookup.
  ///Starts with the existing attendees but will get modified by scan/manual assignment.
  ///Is used to check the selected status of the members
  ///and the contents are used for saving the attendees.
  ///Saving happens after scanning and after manual assignment.
  late HashSet<RideAttendeeScanResult> rideAttendees;

  /// This collection will group the Member uuids of the owners of devices with a given name.
  /// The keys are the device names, while the values are lists of uuid's of Members with a device with the given name.
  HashMap<String, List<String>> ownersGroupedByDevice = HashMap();

  /// This list contains the scanned bluetooth device names.
  final List<String> _scanResults = [];

  /// The scan duration in seconds.
  late int scanDuration;

  /// This HashMap holds the members that were loaded from the database.
  /// Each member is mapped to it's uuid.
  /// This way we can easily map scanned device names to it.
  final HashMap<String, Member> _members = HashMap();

  /// This list holds all the devices that are used during the owner lookup.
  late List<Device> _devices;

  /// This collection contains the owners of
  /// devices that could not be resolved automatically.
  /// A device that could not be resolved has multiple possible owners,
  /// which prevents the automatic selection of the single owner.
  /// (as there are multiple correct selections)
  ///
  /// This list will not contain owners that have already been scanned.
  Set<Member> unresolvedDevicesOwners = HashSet();

  ///Start the initial device scan.
  ///It starts with checking the bluetooth state.
  ///Then it loads the settings and the members / ride attendees.
  ///Finally it starts the device scan.
  ///Any 'generic' errors are caught and pushed to [scanStepStream].
  Future<void> startDeviceScan(
    void Function(String deviceName) onDeviceFound,
  ) async {
    ///Check if bluetooth is on.
    await scanner.isBluetoothEnabled().then((enabled) async {
      if (enabled) {
        scanner.requestScanPermission(
          onDenied: () =>
              _scanStepController.add(ScanProcessStep.permissionDenied),
          onGranted: () async {
            await Future.wait([
              _loadSettings(),
              _loadRideAttendees(ride.date),
              _loadMembersAndDevices()
            ]).then(
              (_) => _startDeviceScan(onDeviceFound),
              onError: _scanStepController.addError,
            );
          },
        );
      } else {
        _scanStepController.add(ScanProcessStep.bluetoothDisabled);
      }
    }, onError: _scanStepController.addError);
  }

  //Perform the actual bluetooth device scan
  void _startDeviceScan(void Function(String deviceName) onDeviceFound) {
    //Start scan if not scanning
    if (!_scanningController.value) {
      _scanningController.add(true);
      _scanStepController.add(ScanProcessStep.scan);

      scanner
          .scanForDevices(scanDuration)
          .where((device) {
            //Remove invalid device names.
            return device.deviceName.trim().isNotEmpty;
          })
          .where((device) {
            //Remove already scanned devices.
            //If not scanned yet, the device is added to the scanned devices list.
            return _scannedDevices.add(device);
          })
          .map((device) => device.deviceName)
          .where(_includeDeviceScanResult)
          .listen(onDeviceFound, onError: (error) {
            //skip the error
          }, onDone: () {
            // Set is scanning to false
            // so the value listenable builder for the button updates.
            // However, only add it when the controller is still available.
            if (!_scanningController.isClosed) {
              _scanningController.add(false);
            }
          }, cancelOnError: false);
    }
  }

  ///Load the application settings.
  Future<void> _loadSettings() async {
    final settings = await settingsRepo.loadApplicationSettings();

    scanDuration = settings.scanDuration;
  }

  Future<List<Member>> loadActiveMembers() {
    return memberRepo.getMembers(MemberFilterOption.active);
  }

  // Load the active members & all devices in parallel.
  // When both are loaded, filter out the devices that don't belong to any active owners.
  Future<void> _loadMembersAndDevices() async {
    await Future.wait([_loadMembers(), _loadDevices()]);

    // Keep the devices that are owned by active members.
    // The _members variable contains all active members.
    // If there is no key for the given device owner, that owner either isn't active or doesn't exist.
    _devices =
        _devices.where((device) => _members[device.ownerId] != null).toList();

    // Now group the uuid's of the owners by device name.
    for (Device device in _devices) {
      if (ownersGroupedByDevice.containsKey(device.name)) {
        // Append the owner uuid to the list of owners for this device.
        ownersGroupedByDevice[device.name]!.add(device.ownerId);
      } else {
        // Create a new list with just this device's owner.
        ownersGroupedByDevice[device.name] = <String>[device.ownerId];
      }
    }
  }

  Future<void> _loadDevices() async {
    _devices = await deviceRepo.getAllDevices();
  }

  /// Load the active members.
  Future<void> _loadMembers() async {
    final List<Member> list =
        await memberRepo.getMembers(MemberFilterOption.active);

    for (final member in list) {
      _members[member.uuid] = member;
    }
  }

  /// Returns whether a given device name should be included in the scan results.
  /// The following devices are included:
  /// - devices of single owners, where the owner wasn't scanned yet
  /// - unknown devices
  /// - devices of multiple owners
  bool _includeDeviceScanResult(String deviceName) {
    final owners = ownersGroupedByDevice[deviceName];

    // It's an unknown device, or a device with multiple possible owners.
    if (owners == null || owners.isEmpty || owners.length > 1) {
      return true;
    }

    // It's a device with exactly one owner.
    // Only include it if the owner wasn't scanned yet.
    return !rideAttendees
        .contains(RideAttendeeScanResult(uuid: owners.first, isScanned: false));
  }

  ///Load the ride attendees and put them in a set.
  ///We need them in a set for easy lookup
  ///during the building of the member list item widgets in the manual step.
  Future<void> _loadRideAttendees(DateTime rideDate) async {
    final items = await ridesRepo.getRideAttendeesAsScanResults(rideDate);

    rideAttendees = HashSet.from(items);
  }

  /// Retrieve the scan result at a given index.
  /// Used by the list builder to fetch data.
  String getScanResultAt(int index) => _scanResults[index];

  void _addRideAttendee(String uuid, bool isScanned) {
    rideAttendees.add(RideAttendeeScanResult(uuid: uuid, isScanned: isScanned));
    _attendeeCountController.add(rideAttendees.length);
  }

  void _removeRideAttendee(RideAttendeeScanResult item) {
    rideAttendees.remove(item);
    _attendeeCountController.add(rideAttendees.length);
  }

  /// Add the given [deviceName] to the scan results list.
  /// If the given device has multiple possible owners,
  /// these [Member]s are added to [unresolvedDevicesOwners].
  /// Results added to
  void addAutomaticScanResult(String deviceName) {
    //Notify the backing list.
    _scanResults.insert(0, deviceName);

    //It's an unknown device, we can't add an owner to the attendees or the multiplePossibleOwners list.
    if (!ownersGroupedByDevice.containsKey(deviceName) ||
        ownersGroupedByDevice[deviceName]!.isEmpty) {
      return;
    }

    // We assume that at this point the owner is not null.
    final Iterable<Member> owners =
        ownersGroupedByDevice[deviceName]!.map((uuid) => _members[uuid]!);

    // This device belongs to multiple possible owners.
    // Add all the owners to the unresolvedDevicesOwners list.
    if (owners.length > 1) {
      unresolvedDevicesOwners.addAll(owners);
    } else {
      // Add the single owner to the attendees instead.
      // The owner was found during a scan.
      _addRideAttendee(owners.first.uuid, true);
    }
  }

  /// Returns a list of members that own a device with the given name.
  List<Member> getDeviceOwners(String deviceName) {
    if (ownersGroupedByDevice.containsKey(deviceName)) {
      return ownersGroupedByDevice[deviceName]!
          .map((String uuid) => _members[uuid]!)
          .toList();
    } else {
      return [];
    }
  }

  ///Stop a running bluetooth scan.
  ///Returns a boolean for WillPopScope (the boolean is otherwise ignored).
  Future<bool> stopScan() async {
    _scanStepController.add(ScanProcessStep.stoppingScan);
    final scanInProgress = _scanningController.value;
    if (!scanInProgress) return true;

    bool result = true;
    await scanner.stopScan().then((_) {
      _scanningController.add(false);
    }).catchError((error) {
      result = false; //if it failed, prevent pop & show error first
      _scanStepController.addError(error);
      _scanningController.add(false);
    });

    return result;
  }

  /// Cancel a running scan.
  /// Once the scan has been stopped, continue to the next screen.
  /// If there are unresolved owners, go to the unresolved owners screen.
  /// Otherwise go to the manual selection.
  void skipScan() async {
    await stopScan().then((scanStopped) {
      if (scanStopped) {
        continueToUnresolvedOwnersList();
      }
    });
  }

  // This variable is used as a locking flag for the item selection.
  // When it is true, no items can be selected.
  bool _isSavingLock = false;

  /// Save the current contents of [rideAttendees] to the database.
  Future<void> saveRideAttendees() async {
    _isSavingLock = true;

    // Now we have the results from all sources:
    // - the scan itself
    // - owner conflict resolution
    // - manual selection
    // - null conversion for old values
    // Count all the scanned members from the entire list.
    ride.scannedAttendees =
        rideAttendees.where((attendee) => attendee.isScanned).length;

    final items = rideAttendees
        .map((element) => RideAttendee(
            rideDate: ride.date,
            uuid: element.uuid,
            isScanned: element.isScanned))
        .toList();

    await ridesRepo.updateRide(ride, items).then<void>((_) {
      _isSavingLock = false;
    }).catchError((error) {
      // Notify the scan step stream, so it shows a generic error.
      _scanStepController.addError(error);
      _isSavingLock = false;
      return Future<void>.error(error);
    });
  }

  /// Go to the unresolved owners list page.
  /// If [unresolvedDevicesOwners.isEmpty] is true,
  /// continue to manual selection instead.
  void continueToUnresolvedOwnersList() {
    if (unresolvedDevicesOwners.isEmpty) {
      continueToManualSelection();
    } else {
      // Resolving the multiple owners is still part of the 'Scan' step.
      _scanStepController.add(ScanProcessStep.resolveMultipleOwners);
    }
  }

  /// Go to the manual selection screen.
  void continueToManualSelection() => _scanStepController.add(
        ScanProcessStep.manual,
      );

  bool isItemSelected(RideAttendeeScanResult item) =>
      rideAttendees.contains(item);

  bool isMemberScanned(String uuid) {
    // Lookup the item with the given uuid.
    // Thanks to [RideAttendeeScanResult]'s equality, isScanned is irrelevant.
    final item = rideAttendees.lookup(
      RideAttendeeScanResult(uuid: uuid, isScanned: false),
    );

    // If we don't find the item, the given UUID is not scanned (and not manually selected either).
    return item != null && item.isScanned;
  }

  /// Members can be selected if we are not saving.
  bool get canSelectMember => !_isSavingLock;

  bool scanResultExists(RideAttendeeScanResult item) {
    return rideAttendees.contains(item);
  }

  void removeScanResult(RideAttendeeScanResult item) => _removeRideAttendee;

  void addManualScanResult(String uuid) => _addRideAttendee(uuid, false);

  void onMemberSelectedWithoutConfirmationDialog(
    RideAttendeeScanResult member,
  ) {
    if (rideAttendees.contains(member)) {
      _removeRideAttendee(member);
    } else {
      // A person was selected that isn't an attendee yet.
      // This person was 'found' manually.
      _addRideAttendee(member.uuid, false);
    }
  }

  int get rideAttendeeCount => rideAttendees.length;

  // Remove the already scanned owners and sort the remaining ones.
  // This is useful for preparing the multiple owners resolution list screen.
  Future<List<Member>> filterAndSortMultipleOwnersList() {
    final filtered = unresolvedDevicesOwners.where((Member member) {
      return !rideAttendees.contains(
        RideAttendeeScanResult(uuid: member.uuid, isScanned: false),
      );
    }).toList();

    filtered.sort((Member m1, Member m2) => m1.compareTo(m2));

    return Future.value(filtered);
  }

  @override
  void dispose() {
    _scanStepController.close();
    _scanningController.close();
    _attendeeCountController.close();
    _queryController.close();
    _showScannedController.close();
  }
}
