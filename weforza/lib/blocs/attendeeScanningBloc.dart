
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/scanResultItem.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';

///TODO use page nr with pagesize in _loadMembers(pageSize,pageNr)
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

  final List<ScanResultItem> _scanResults = [];

  ///The page number for the members that should get loaded.
  ///This number starts at 0 but changes over time
  ///(when scrolling in the manual step)
  int memberListPageNr = 0;
  ///The amount of elements in a single page.
  int pageSize = 40;

  ///A subset of the total members is stored here.
  ///Currently it's not a subset but the full list.
  List<Member> currentMembersList;

  ///This controller maintains the general UI state as divided in steps by [ScanProcessStep].
  ///For each step it will trigger a rebuild of the UI accordingly.
  StreamController<ScanProcessStep> _scanStepController = BehaviorSubject();
  Stream<ScanProcessStep> get scanStepStream => _scanStepController.stream;

  ///Start the initial device scan.
  ///This is invoked when the scanning page is first loaded.
  ///It starts with checking the bluetooth state.
  ///Then it loads the settings and the members / ride attendees.
  ///Finally it starts the device scan.
  ///Any 'generic' errors are caught and pushed to [scanStepStream].
  ///This function takes a lambda that gets the device name of a found device and the lookup future for getting the member.
  Future<void> startDeviceScan(void Function(String deviceName, Future<Member> memberLookup) onDeviceFound) async {
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
              _loadMembers(pageSize, page: memberListPageNr)
            ]).then((_) async => _startDeviceScan(onDeviceFound), onError: (error){
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
  void _startDeviceScan(void Function(String deviceName, Future<Member> memberLookup) onDeviceFound){
    //Start scan if not scanning
    if(!isScanning.value){
      isScanning.value = true;
      _scanStepController.add(ScanProcessStep.SCAN);
      scanner.scanForDevices(Settings.instance.scanDuration).listen((deviceName) {
        //Start the lookup for the member, giving the device name as placeholder.
        onDeviceFound(deviceName, _findOwnerOfDevice(deviceName));
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
  Future<void> _loadSettings() => settingsRepo.loadApplicationSettings();

  ///Load the members subset (is better for memory usage).
  ///Has a page parameter (ignored for now).
  Future<void> _loadMembers(int pageSize, {int page = 0}) async {
    currentMembersList = await memberRepo.getMembers();
  }

  ///Load the ride attendees and put them in a set.
  ///We need them in a set for easy lookup
  ///during the building of the member list item widgets in the manual step.
  Future<void> _loadRideAttendees(DateTime rideDate) async {
    final members = await ridesRepo.getRideAttendees(rideDate);
    rideAttendees = HashSet.from(members.map((member) => member.uuid).toList());
  }

  ///Find the owner of the given device.
  ///If the owner is found, it is stored in [rideAttendees].
  ///Everything in [rideAttendees] gets saved when the user confirms.
  ///Returns the [Member] that is the owner or null if not found.
  Future<Member> _findOwnerOfDevice(String deviceName) async {
    //Find the device owner ID
    final device = await deviceRepo.getDeviceWithName(deviceName);
    if(device == null){
      return null;
    }
    //Find the owner by id
    final owner = await memberRepo.getMemberByUuid(device.ownerId);
    if(owner == null){
      return null;
    }else{
      rideAttendees.add(device.ownerId);
      return owner;
    }
  }

  ScanResultItem getScanResultAt(int index) => _scanResults[index];

  void addScanResult(ScanResultItem item) => _scanResults.insert(0, item);

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
  ///This preserves old results.
  ///[mergeResults] should only be true during the Scan step.
  ///If [continueToManualAssignment] is true, the manual assignment screen will show up after saving is done.
  ///[continueToManualAssignment] should only be true during the Scan step.
  Future<void> saveRideAttendees(bool mergeResults, bool continueToManualAssignment) async {
    isSaving.value = true;
    await ridesRepo.updateAttendeesForRideWithDate(
        rideDate,
        rideAttendees.map((element) => RideAttendee(rideDate, element)),
        mergeResults
    ).then((_){
        if(continueToManualAssignment){
          isSaving.value = false;
          isScanStep.value = false;
          _scanStepController.add(ScanProcessStep.MANUAL);
        }
      //The manual assignment step will pop when submitted.
      //To make it look smoother, we show the loading indicator during the pop in manual submit.
      //That's why we don't set isSaving to false if continueToManualAssignment is true.
      },
      onError: (error){
        _scanStepController.addError(error);
        isSaving.value = false;
        return Future.error(error);
      },
    );
  }

  ///Check the required permission for starting a scan.
  ///When the permission is unknown, it is requested first.
  ///After requesting the permission, the proper callback is called.
  ///When the permission was granted before [onGranted] gets called.
  ///When the permission is denied, [onDenied] gets called.
  void requestScanPermission({
    void Function() onGranted,
    void Function() onDenied,
  }) async {
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
}

enum ScanProcessStep {
  INIT,//Check bluetooth on, then load settings and members
  SCAN,//scanning
  MANUAL,//scanning results were confirmed and we are in the manual assignment step
  BLUETOOTH_DISABLED,//bluetooth is off
  STOPPING_SCAN,//the scan is stopping
  PERMISSION_DENIED,//the app didn't have the required permission to start scanning.
}