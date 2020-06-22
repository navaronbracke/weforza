
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/scanResultItem.dart';
import 'package:weforza/model/settings/settings.dart';
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
  Future<void> doInitialDeviceScan(void Function(String deviceName, Future<Member> memberLookup) onDeviceFound) async {
    ///Check if bluetooth is on.
    await scanner.isBluetoothEnabled().then((value) async {
      if(value){
        ///Wait for both the settings and the existing attendees/ first page of members.
        ///Fail fast when either fails.
        await Future.wait([_loadSettings(), _loadRideAttendees(rideDate), _loadMembers(pageSize, page: memberListPageNr)]).then((_) async {
          if(currentMembersList == null || currentMembersList.isEmpty){
            _scanStepController.add(ScanProcessStep.NO_MEMBERS);
          }else{
            //Start scan if not scanning
            if(!isScanning.value){
              isScanning.value = true;
              _scanStepController.add(ScanProcessStep.SCAN);
              scanner.scanForDevices(Settings.instance.scanDuration).listen((deviceName) {
                //Start the lookup for the member, giving the device name as placeholder.
                onDeviceFound(deviceName, _findOwnerOfDevice(deviceName));
              }, onError: (error){
                //ignore scan errors
              }, onDone: (){
                //Set is scanning to false
                //so the value listenable builder for the button updates.
                //At this point the user can also switch pages.
                isScanning.value = false;
              });
            }
          }
        }, onError: (error){
          //Catch the settings/member load errors.
          //This is a generic error and is thus caught by the StreamBuilder.
          _scanStepController.addError(error);
        });
      }else{
        _scanStepController.add(ScanProcessStep.BLUETOOTH_DISABLED);
      }
    }, onError: (error){
      //Catch the check bluetooth error.
      //This is a generic error and is thus caught by the StreamBuilder.
      _scanStepController.addError(error);
    });
  }

  ///Retry the device scan.
  ///This function is essentially [doInitialDeviceScan] but without the data loading.
  Future<void> retryDeviceScan(void Function(String deviceName, Future<Member> memberLookup) onDeviceFound) async {
    //Reset the UI to show the initial loading indicator again.
    _scanStepController.add(ScanProcessStep.INIT);
    ///Check if bluetooth is on.
    await scanner.isBluetoothEnabled().then((value) async {
      if(value){
        //Start scan if not scanning
        if(!isScanning.value){
          isScanning.value = true;
          _scanStepController.add(ScanProcessStep.SCAN);
          scanner.scanForDevices(Settings.instance.scanDuration).listen((deviceName) {
            //Start the lookup for the member, giving the device name as placeholder.
            onDeviceFound(deviceName, _findOwnerOfDevice(deviceName));
          }, onError: (error){
            //ignore scan errors
          }, onDone: (){
            //Set is scanning to false
            //so the value listenable builder for the button updates.
            //At this point the user can also switch pages.
            isScanning.value = false;
          });
        }
      }else{
        _scanStepController.add(ScanProcessStep.BLUETOOTH_DISABLED);
      }
    }, onError: (error){
      //Catch the check bluetooth error.
      //This is a generic error and is thus caught by the StreamBuilder.
      _scanStepController.addError(error);
    });
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

  void addScanResult(ScanResultItem item) => _scanResults.add(item);

  ///Stop a running scan.
  ///Returns a boolean for WillPopScope (the boolean is otherwise ignored).
  Future<bool> stopScan() async {
    if(!isScanning.value) return true;

    bool result = true;
    await scanner.stopScan().then((_){
      isScanning.value = false;
      rideAttendees.clear();
    }, onError: (error){
      result = false;//if it failed, prevent pop & show error first
      _scanStepController.addError(error);
      isScanning.value = false;
    });

    return result;
  }

  ///Cancel a running scan and continue to the manual assignment step.
  void skipScan() async {
    await stopScan().then(
            (_) => _scanStepController.add(ScanProcessStep.MANUAL)
    );
  }

  Future<void> saveScanResults([bool continueToManualAssignment = true]) async {
    isSaving.value = true;
    final List<RideAttendee> attendeesToSave = rideAttendees.map((element) => RideAttendee(rideDate, element)).toList();
    await ridesRepo.updateAttendeesForRideWithDate(rideDate, attendeesToSave).then((_){
        if(continueToManualAssignment){
          isSaving.value = false;
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
  
  Future<File> loadProfileImage(String path) => memberRepo.loadProfileImageFromDisk(path);

  @override
  void dispose() {
    _scanStepController.close();
  }

  bool isItemSelected(Member item) => rideAttendees.contains(item.uuid);

  void addMember(Member item) => rideAttendees.add(item.uuid);

  loadProfileImageFromDisk(String path) => memberRepo.loadProfileImageFromDisk(path);
}

enum ScanProcessStep {
  INIT,//Check bluetooth on, then load settings and members
  SCAN,//scanning
  MANUAL,//scanning results were confirmed and we are in the manual assignment step
  BLUETOOTH_DISABLED,//bluetooth is off
  NO_MEMBERS,//there are no members to pick from
}