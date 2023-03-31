
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
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

  final StreamController<bool> _choiceRequiredStreamController = BehaviorSubject.seeded(false);
  Stream<bool> get choiceRequiredStream => _choiceRequiredStreamController.stream;

  final StreamController<bool> _menuEnabledStreamController = BehaviorSubject.seeded(false);
  Stream<bool> get menuEnabledStream => _menuEnabledStreamController.stream;

  final StreamController<String> _lastSelectedOwnerStreamController = BehaviorSubject.seeded(null);
  Stream<String> get lastSelectedOwnerStream => _lastSelectedOwnerStreamController.stream;

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

  HashMap<String, Member> membersList;

  ///This controller maintains the general UI state as divided in steps by [ScanProcessStep].
  ///For each step it will trigger a rebuild of the UI accordingly.
  StreamController<ScanProcessStep> _scanStepController = BehaviorSubject();
  Stream<ScanProcessStep> get scanStepStream => _scanStepController.stream;

  /// Returns true if the given [deviceName] has a single owner, that is not present in [rideAttendees].
  /// In other words, this filters out devices, of which the single owner was already scanned.
  bool _filterDeviceWhenSingleOwnerAndOwnerIsAlreadyAttending(String deviceName){
    //Single owner & not attending already
    return deviceOwners[deviceName].length == 1 && !rideAttendees.contains(deviceOwners[deviceName].first);
  }

  ///Start the initial device scan.
  ///It starts with checking the bluetooth state.
  ///Then it loads the settings and the members / ride attendees.
  ///Finally it starts the device scan.
  ///Any 'generic' errors are caught and pushed to [scanStepStream].
  Future<void> startDeviceScan(void Function(String deviceName) onDeviceFound) async {
    ///Check if bluetooth is on.
    await scanner.isBluetoothEnabled().then((enabled) async {
      if(enabled){
        requestScanPermission(
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
      final Set<BluetoothPeripheral> scannedDevices = HashSet();
      isScanning.value = true;
      _scanStepController.add(ScanProcessStep.SCAN);

      scanner.scanForDevices(scanDuration).where(
              (BluetoothPeripheral device) => _filterDeviceWhenSingleOwnerAndOwnerIsAlreadyAttending(device.deviceName)
      ).listen((BluetoothPeripheral device) {
        if(!scannedDevices.contains(device)){
          scannedDevices.add(device);
          onDeviceFound(device.deviceName);
        }
      }, onError: (error){
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
    deviceOwners = await deviceRepo.getDeviceOwners();
  }

  /// Load the members. Returns a HashMap for easy lookup later.
  Future<void> _loadMembers() async {
    membersList = await memberRepo.getMembers().then((List<Member> list){
      final HashMap<String,Member> collection = HashMap();
      list.forEach((Member member) => collection[member.uuid] = member);

      return collection;
    });
  }

  ///Load the ride attendees and put them in a set.
  ///We need them in a set for easy lookup
  ///during the building of the member list item widgets in the manual step.
  Future<void> _loadRideAttendees(DateTime rideDate) async {
    final members = await ridesRepo.getRideAttendees(rideDate);
    rideAttendees = HashSet.from(members.map((member) => member.uuid).toList());
  }

  String getScanResultAt(int index) => _scanResults[index];

  void addScanResult(String item) => _scanResults.insert(0, item);

  List<Member> getDeviceOwners(String deviceName) {
    if(deviceOwners.containsKey(deviceName)){
      return deviceOwners[deviceName].map((String uuid) => membersList[uuid]).toList();
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
    }, onError: (error){
      result = false;//if it failed, prevent pop & show error first
      _scanStepController.addError(error);
      isScanning.value = false;
    });

    return result;
  }

  ///Cancel a running scan and continue to the manual assignment step.
  void skipScan() async {
    await stopScan().then((scanStopped){
      if(scanStopped){
        _scanStepController.add(ScanProcessStep.MANUAL);
        isScanStep.value = false;
      }
    });
  }

  ///Save the current contents of [rideAttendees] to the database.
  ///[mergeResults] dictates if the contents of [rideAttendees] should be merged in with the existing data.
  ///[mergeResults] should only be true during the Scan step.
  Future<void> saveRideAttendees(bool mergeResults) async {
    isSaving.value = true;
    await ridesRepo.updateAttendeesForRideWithDate(
        rideDate,
        rideAttendees.map((element) => RideAttendee(rideDate, element)),
        mergeResults
    ).catchError((error){
      _scanStepController.addError(error);
      isSaving.value = false;
      return Future.error(error);
    });
  }

  void advanceScanProcessStepToManualSelection(){
    isSaving.value = false;
    isScanStep.value = false;
    _scanStepController.add(ScanProcessStep.MANUAL);
  }

  ///Check the required permission for starting a scan.
  ///When the permission is unknown, it is requested first.
  ///After requesting the permission, the proper callback is called.
  ///When the permission was granted before [onGranted] gets called.
  ///When the permission is denied, [onDenied] gets called.
  void requestScanPermission({void Function() onGranted, void Function() onDenied}) async {
    if(await Permission.locationWhenInUse.request().isGranted){
      onGranted();
    }else{
      onDenied();
    }
  }
  
  Future<File> loadProfileImage(String path) => memberRepo.loadProfileImageFromDisk(path);

  @override
  void dispose() {
    _scanStepController.close();
    _choiceRequiredStreamController.close();
    _menuEnabledStreamController.close();
    _lastSelectedOwnerStreamController.close();
  }

  bool isItemSelected(Member item) => rideAttendees.contains(item.uuid);

  void onMemberSelected(Member item){
    if(rideAttendees.contains(item.uuid)){
      rideAttendees.remove(item.uuid);
    }else{
      rideAttendees.add(item.uuid);
    }
  }

  loadProfileImageFromDisk(String path) => memberRepo.loadProfileImageFromDisk(path);

  /// Remove [oldOwner] from the list of attendees and add [newOwner] instead.
  void replaceDeviceOwner(String oldOwner, String newOwner) {
    rideAttendees.remove(oldOwner);//null can't be in here anyway.
    rideAttendees.add(newOwner);//it's a Set so duplicates do nothing.
  }
}