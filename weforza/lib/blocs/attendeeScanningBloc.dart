
import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';
import 'package:weforza/bluetooth/bluetoothPeripheral.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/scanProcessStep.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';

class AttendeeScanningBloc extends Bloc {
  AttendeeScanningBloc({
    @required this.rideDate,
    @required this.scanner,
    @required this.settingsRepo,
    @required this.memberRepo,
    @required this.deviceRepo,
    @required this.ridesRepo,
  }): assert(
  scanner != null && rideDate != null && settingsRepo != null
      && memberRepo != null && deviceRepo != null && ridesRepo != null
  );

  ///The bluetooth scanner that will do bluetooth stuff for us.
  final BluetoothDeviceScanner scanner;

  ///The already scanned devices are stored here.
  ///This prevents duplicates during the scan.
  final Set<BluetoothPeripheral> _scannedDevices = HashSet();

  ///A value notifier for the scanning boolean.
  ///We use it to check if we can pop the widget scope
  ///and what button to show (skip or save scan).
  ///It also manages the visibility of the scan progress indicator.
  final ValueNotifier<bool> isScanning = ValueNotifier<bool>(false);

  ///A value notifier for the saving boolean.
  ///We use it to show a loading indicator or show scan related buttons.
  final ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);

  ///This value notifier manages the state for the selected label in the UI.
  ///It gets updated after the scan save step.
  ///We keep track of this separately,
  ///since the step chance shouldn't prevent
  ///the user from going back to the details screen.
  final ValueNotifier<bool> isScanStep = ValueNotifier<bool>(true);

  ///The repositories connect the bloc with the database.
  final SettingsRepository settingsRepo;
  final MemberRepository memberRepo;
  final DeviceRepository deviceRepo;
  final RideRepository ridesRepo;

  ///The date of the ride that will get attendees assigned
  ///during the scan / manual assignment.
  final DateTime rideDate;

  ///The scan future is stored here.
  ///During init state [doInitialDeviceScan] is stored here.
  ///When a user retries a scan, [retryDeviceScan] is stored here.
  ///This future is not used by a FutureBuilder since the UI is managed by a StreamBuilder.
  Future<void> scanFuture;

  ///Store the ride attendees in a hash set for easy lookup.
  ///Starts with the existing attendees but will get modified by scan/manual assignment.
  ///Is used to check the selected status of the members
  ///and the contents are used for saving the attendees.
  ///Saving happens after scanning and after manual assignment.
  HashSet<String> rideAttendees;

  /// This collection will group the Member uuids of the owners of devices with a given name.
  /// The keys are the device names, while the values are lists of uuid's of Members with a device with the given name.
  HashMap<String, List<String>> deviceOwners;

  /// This list contains the scanned bluetooth device names.
  final List<String> _scanResults = [];
  /// The scan duration in seconds.
  int scanDuration;

  /// This HashMap holds the members that were loaded from the database.
  /// Each member is mapped to it's uuid.
  /// This way we can easily map scanned device names to it.
  HashMap<String, Member> _members = HashMap();

  /// This collection will keep a duplicate, sorted version, of [members.values].
  /// This gives us the advantage of still being able to do the efficient HashMap lookup.
  /// Albeit with increased memory footprint, for the ordered collection.
  List<Member> sortedMembers;

  /// This collection keeps track of a specific set of owners.
  /// If a device with multiple possible owners is scanned,
  /// the owners that aren't scanned yet (by finding a device only they own)
  /// are added to this list.
  ///
  /// This list effectively collects the owners
  /// that are passed to the multiple possible owners resolution screen.
  /// On this screen the user can select the members from this list that weren't automatically resolved.
  Set<Member> ownersOfScannedDevicesWithMultiplePossibleOwners = HashSet();

  ///This controller maintains the general UI state as divided in steps by [ScanProcessStep].
  ///For each step it will trigger a rebuild of the UI accordingly.
  StreamController<ScanProcessStep> _scanStepController = BehaviorSubject();
  Stream<ScanProcessStep> get scanStepStream => _scanStepController.stream;

  ///Start the initial device scan.
  ///It starts with checking the bluetooth state.
  ///Then it loads the settings and the members / ride attendees.
  ///Finally it starts the device scan.
  ///Any 'generic' errors are caught and pushed to [scanStepStream].
  Future<void> startDeviceScan(void Function(String deviceName) onDeviceFound) async {
    ///Check if bluetooth is on.
    await scanner.isBluetoothEnabled().then((enabled) async {
      if(enabled){
        scanner.requestScanPermission(
          onDenied: () => _scanStepController.add(ScanProcessStep.PERMISSION_DENIED),
          onGranted: () async {
            ///Wait for both the settings and the existing attendees/ first page of members.
            ///Fail fast when either fails.
            await Future.wait([
              _loadSettings(),
              _loadRideAttendees(rideDate),
              _loadMembers(),
              _loadDeviceOwners(),
            ]).then((_) => _startDeviceScan(onDeviceFound), onError: (error){
              //Catch the settings/member load errors.
              //This is a generic error and is thus caught by the StreamBuilder.
              _scanStepController.addError(error);
            });
          },
        );
      }else{
        _scanStepController.add(ScanProcessStep.BLUETOOTH_DISABLED);
      }
    }, onError: (error){
      //Catch the check bluetooth error.
      //This is a generic error and is thus caught by the StreamBuilder.
      _scanStepController.addError(error);
    });
  }

  //Perform the actual bluetooth device scan
  void _startDeviceScan(void Function(String deviceName) onDeviceFound){
    //Start scan if not scanning
    if(!isScanning.value){

      isScanning.value = true;
      _scanStepController.add(ScanProcessStep.SCAN);

      //Start the scan.
      //Filters the already scanned devices.
      //Then maps the result to the device name.
      //And finishes by filtering the devices of which there is only one owner, that was already scanned.
      scanner.scanForDevices(scanDuration)
          .where((device){
            //Remove invalid device names.
            return device != null && device.deviceName != null && device.deviceName.trim().isNotEmpty;
          })
          .where((device){
            //Remove already scanned devices.
            //If not scanned yet, the device is added to the scanned devices list.
            return _scannedDevices.add(device);
          })
          .map((device) => device.deviceName)
          .where(_deviceOwnerNotScanned)
          .listen(onDeviceFound, onError: (error){
            //skip the error
      }, onDone: (){
        //Set is scanning to false
        //so the value listenable builder for the button updates.
        //At this point the user can also switch pages.
        isScanning.value = false;
      }, cancelOnError: false);
    }
  }

  ///Load the application settings.
  Future<void> _loadSettings() async {
    await settingsRepo.loadApplicationSettings();
    scanDuration = settingsRepo.instance.scanDuration;
  }

  /// Load the device owners.
  Future<void> _loadDeviceOwners() async {
    deviceOwners = await deviceRepo.getOwnersOfAllDevices();
  }

  /// Load the members. Returns a HashMap for easy lookup later.
  Future<void> _loadMembers() async {
    sortedMembers = await memberRepo.getMembers();
    sortedMembers.forEach((Member member) => _members[member.uuid] = member);
  }

  /// Returns whether the single owner of the given [deviceName] wasn't scanned yet.
  bool _deviceOwnerNotScanned(String deviceName){
    final owners = deviceOwners[deviceName];

    // Unknown devices or devices with multiple possible owners.
    if(owners == null || owners.isEmpty || owners.length > 1){
      return true;
    }else {
      // An owner that wasn't scanned yet.
      return !rideAttendees.contains(owners.first);
    }
  }

  ///Load the ride attendees and put them in a set.
  ///We need them in a set for easy lookup
  ///during the building of the member list item widgets in the manual step.
  Future<void> _loadRideAttendees(DateTime rideDate) async {
    final members = await ridesRepo.getRideAttendees(rideDate);
    rideAttendees = HashSet.from(members.map((member) => member.uuid).toList());
  }

  /// Retrieve the scan result at a given index.
  /// Used by the list builder to fetch data.
  String getScanResultAt(int index) => _scanResults[index];

  /// Add the given [deviceName] to the scan results list.
  /// If the given device has multiple possible owners,
  /// these [Member]s are added to [ownersOfScannedDevicesWithMultiplePossibleOwners].
  void addScanResult(String deviceName){
    //Notify the backing list.
    _scanResults.insert(0, deviceName);

    //It's an unknown device, we can't add an owner to the attendees or the multiplePossibleOwners list.
    if(deviceOwners[deviceName] == null || deviceOwners[deviceName].isEmpty){
      return;
    }

    final Iterable<Member> owners = deviceOwners[deviceName].map((uuid) => _members[uuid]);

    if(owners.length > 1){
      ownersOfScannedDevicesWithMultiplePossibleOwners.addAll(owners);
    }else{
      //Add the single owner to the attendees instead.
      rideAttendees.add(owners.first.uuid);
    }
  }

  List<Member> getDeviceOwners(String deviceName) {
    if(deviceOwners.containsKey(deviceName)){
      return deviceOwners[deviceName].map((String uuid) => _members[uuid]).toList();
    }else{
      return [];
    }
  }

  ///Stop a running bluetooth scan.
  ///Returns a boolean for WillPopScope (the boolean is otherwise ignored).
  Future<bool> stopScan() async {
    _scanStepController.add(ScanProcessStep.STOPPING_SCAN);
    if(!isScanning.value) return true;

    bool result = true;
    await scanner.stopScan().then((_){
      isScanning.value = false;
    }).catchError((error){
      result = false;//if it failed, prevent pop & show error first
      _scanStepController.addError(error);
      isScanning.value = false;
    });

    return result;
  }

  ///Cancel a running scan and continue to the next step.
  ///This can lead to either manual selection or owner resolution.
  void skipScan() async {
    await stopScan().then((scanStopped){
      if(scanStopped){
        tryAdvanceToManualSelection();
      }
    });
  }

  /// Save the current contents of [rideAttendees] to the database.
  Future<void> saveRideAttendees() async {
    isSaving.value = true;
    await ridesRepo.updateAttendeesForRideWithDate(
        rideDate,
        rideAttendees.map((element) => RideAttendee(rideDate, element))
    ).catchError((error){
      _scanStepController.addError(error);
      isSaving.value = false;
      return Future.error(error);
    });
  }

  /// Try to go to the manual selection screen.
  /// If we have items in [ownersOfScannedDevicesWithMultiplePossibleOwners],
  /// we go to the multiple owners resolution screen and [isScanStep] stays true.
  /// Otherwise we go to the manual selection screen and [isScanStep] becomes false.
  ///
  /// If [override] is true, we go to manual selection anyway.
  void tryAdvanceToManualSelection({bool override = false}){
    if(override || ownersOfScannedDevicesWithMultiplePossibleOwners.isEmpty){
      //Multiple invocations of this method, cannot alter isScanning.
      if(isScanStep.value){
        isScanStep.value = false;
      }
      _scanStepController.add(ScanProcessStep.MANUAL);
    }else{
      // There are owners that we cannot resolve ourselves, scan step stays unmodified.
      _scanStepController.add(ScanProcessStep.RESOLVE_MULTIPLE_OWNERS);
    }
  }

  @override
  void dispose() {
    _scanStepController.close();
  }

  bool isItemSelected(String uuid) => rideAttendees.contains(uuid);

  void onMemberSelected(String memberUuid){
    if(rideAttendees.contains(memberUuid)){
      rideAttendees.remove(memberUuid);
    }else{
      rideAttendees.add(memberUuid);
    }
  }

  Future<List<Member>> filterAndSortMultipleOwnersList() {
    final filtered = ownersOfScannedDevicesWithMultiplePossibleOwners.where((Member member) => !rideAttendees.contains(member.uuid)).toList();

    filtered.sort((Member m1, Member m2) => m1.compareTo(m2));

    return Future.value(filtered);
  }
}