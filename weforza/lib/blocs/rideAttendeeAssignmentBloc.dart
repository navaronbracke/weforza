
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/rideAttendeeSelector.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeScanner.dart';

class RideAttendeeAssignmentBloc extends Bloc implements RideAttendeeSelector,RideAttendeeScanner {
  RideAttendeeAssignmentBloc(this.ride,this._rideRepository,this._memberRepository,this._deviceRepository):
        assert(ride != null && _memberRepository != null && _rideRepository != null && _deviceRepository != null);

  ///The [Ride] for which to change the attendees.
  final Ride ride;
  final RideRepository _rideRepository;
  final MemberRepository _memberRepository;
  final DeviceRepository _deviceRepository;

  ///The [FlutterBlue] instance that will handle the scanning.
  final FlutterBlue bluetoothScanner = FlutterBlue.instance;

  ///Whether the scan is cancelled
  bool isCanceled = false;
  
  ///The list of devices that were scanned.
  List<String> scannedDevices;

  ///The members contain the fully loaded [MemberItem]s and their selection state.
  ///They are stored here so the scanning widget won't have to reload the members during its init step.
  ///This way it only needs to load the devices and put both the members and devices into their respective Map.
  ///The key is the member id.
  Map<String,RideAttendeeAssignmentItemBloc> members;

  ///The devices of all members are stored here.
  ///The key is the device name.
  ///The value is the ID of the member.
  Map<String,String> devices;

  ///This [BehaviorSubject] controls whether the page actions should be shown.
  final StreamController<bool> _actionsDisplayModeController = BehaviorSubject();
  Stream<bool> get actionsDisplayModeStream => _actionsDisplayModeController.stream;

  ///This [BehaviorSubject] controls what content page is shown.
  final StreamController<RideAttendeeAssignmentContentDisplayMode> _contentDisplayModeController = BehaviorSubject();
  Stream<RideAttendeeAssignmentContentDisplayMode> get contentDisplayModeStream => _contentDisplayModeController.stream;

  ///This [BehaviorSubject] controls the scanning process.
  final StreamController<ScanStep> _scanController = BehaviorSubject();

  @override
  Stream<ScanStep> get scanStream => _scanController.stream;

  ///The UUID's of the [Member]s that should be saved as Attendees of [ride] on submit.
  List<String> _rideAttendees;

  Future<List<RideAttendeeAssignmentItemBloc>> loadMembers() async {
    _actionsDisplayModeController.add(false);
    final itemsFromDb = await _memberRepository.getMembers();
    if(itemsFromDb.isNotEmpty){
      members = {};
      _rideAttendees = List();
      //Load the attendee ID's of the current attendees
      final attendees = await _memberRepository.getRideAttendeeIds(ride.date);
      await Future.wait(itemsFromDb.map((member)=> _mapMemberToItem(member,attendees.contains(member.uuid))));

      _actionsDisplayModeController.add(true);
      _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.LIST);
    }
    return members.values.toList();
  }

  Future<void> _mapMemberToItem(Member member,bool selected) async {
    final item = RideAttendeeAssignmentItemBloc(
        MemberItem(member,await _memberRepository.loadProfileImageFromDisk(member.profileImageFilePath)),
        selected,
        this
    );
    if(selected){
      //if it was stored as an attendee, add to the list
      _rideAttendees.add(item.member.uuid);
    }
    members.putIfAbsent(item.member.uuid, ()=> item);
  }

  Future<void> onSubmit() async {
    _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.SAVE);
    _actionsDisplayModeController.add(false);
    await _rideRepository.updateAttendeesForRideWithDate(ride, _rideAttendees.map(
            (uuid)=> RideAttendee(ride.date,uuid)).toList()
    ).then((_){
      RideProvider.reloadRides = true;
      RideProvider.selectedRide = ride;
    });
  }

  String getTitle(BuildContext context){
    return S.of(context).RideAttendeeAssignmentTitle(
        DateFormat("d/M/yyyy", Localizations.localeOf(context).languageCode)
            .format(ride.date));
  }

  ///Start a scan.
  ///This stream yields null because it delegates its results to a [BehaviorSubject].
  ///This subject holds on to the latest value.
  ///This way the scan can proceed without issues during config changes.
  @override
  Stream<void> startScan(
      VoidCallback onAlreadyScanning, VoidCallback onGenericScanError,
      void Function(int numberOfResults) onScanResultsReceived, VoidCallback onScanStarted) async*
  {
    for(ScanStep s in ScanStep.values){
      if(!isCanceled){
        _handleScanStep(
            s,
            onAlreadyScanning,
            onGenericScanError,
            onScanResultsReceived,
            onScanStarted,
        );
        yield null;
      }
    }
  }

  void _handleScanStep(ScanStep currentStep, VoidCallback onAlreadyScanning,
      VoidCallback onGenericScanError, void Function(int numberOfResults) onScanResultsReceived, VoidCallback onScanStarted) async {
    _scanController.add(currentStep);
    if(currentStep == ScanStep.LOAD_DEVICES){
      //Load devices
      scannedDevices = List();
      await _loadDevicesToScanFor().catchError((e)=> onGenericScanError());
    }else if(currentStep == ScanStep.DO_SCAN){
      //Start scan
      await _startBluetoothScan(onAlreadyScanning,onGenericScanError,onScanResultsReceived,onScanStarted).catchError((e)=> onGenericScanError());
    }else if(currentStep == ScanStep.PROCESS){
      await _processResults(scannedDevices);
    }
  }


  ///Load the devices to scan for when a scan is started.
  ///This is the [ScanningState.INITIALIZING] step.
  Future<void> _loadDevicesToScanFor() async {
    devices = {};
    final items = await _deviceRepository.getAllDevices();
    items.forEach((device){
      devices.putIfAbsent(device.name, () => device.ownerId);
    });
  }

  ///Start a bluetooth scan.
  ///This is the [ScanningState.SCANNING] step.
  Future<void> _startBluetoothScan(
      VoidCallback onAlreadyScanning,
      VoidCallback onGenericScanError,
      void Function(int numberOfResults) onScanResultsReceived, VoidCallback onScanStarted) async {
    await bluetoothScanner.isOn.then((value) async {
      if(!value){
        onGenericScanError();
      }else{
        await bluetoothScanner.isScanning.first.then((value) async {
          if(value != null && value){
            onAlreadyScanning();
          }else{
            bluetoothScanner.scanResults.listen((result){
              result.removeWhere((res) => devices[res.device.name] == null);
              onScanResultsReceived(result.length);
              scannedDevices.addAll(result.map((r)=>r.device.name).toList());
            }).onError((e){
              //An error will not stop the stream, so we ignore any errors here
              //In the next scan result, if it is successful, it will recover from the previous error
            });
            onScanStarted();
            await bluetoothScanner.startScan(timeout: Duration(seconds: 20)).catchError((e){
              onGenericScanError();
            });
          }
        }).catchError((e){
          onGenericScanError();
        });
      }
    }).catchError((e){
      onGenericScanError();
    });
  }

  ///Process the [foundDevices].
  ///Eliminate duplicates and notify the owners.
  ///This is the [ScanStep.PROCESS] step.
  Future<void> _processResults(List<String> foundDevices){
    ///The processed devices, stored with a has duplicates flag.
    ///The key is the device name, the value is whether it has duplicates.
    final Map<String,bool> processedDevices = {};
    foundDevices.forEach((deviceName){
      //Lookup a possible value
      final value = processedDevices[deviceName];
      //if not found(no duplicates yet), add it with false otherwise set it to true
      processedDevices[deviceName] = value == null ? false : true;
    });
    processedDevices.removeWhere((key,value)=> value == true);
    processedDevices.keys.forEach((deviceName){
      final owner = members[devices[deviceName]];
      if(owner != null && owner.selected == false){
        select(owner);
      }
    });
    return null;
  }

  @override
  void stopScan() async {
    isCanceled = true;
    await bluetoothScanner.stopScan().then((_) async {
      _scanController.add(ScanStep.PROCESS);
      await _processResults(scannedDevices);
      _scanController.add(ScanStep.DONE);
      _actionsDisplayModeController.add(true);
      _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.LIST);
    });
  }

  void onRequestScan(VoidCallback onBluetoothDisabled) async {
    await bluetoothScanner.isOn.then((isOn){
      if(isOn){
        _actionsDisplayModeController.add(false);
        _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.SCAN);
      }else{
        onBluetoothDisabled();
      }
    });
  }

  @override
  void select(RideAttendeeAssignmentItemBloc item) {
    if(!_rideAttendees.contains(item.member.uuid)){
      _rideAttendees.add(item.member.uuid);
      item.selected = true;
    }
  }

  @override
  void unSelect(RideAttendeeAssignmentItemBloc item) {
    if(_rideAttendees.contains(item.member.uuid)){
      _rideAttendees.remove(item.member.uuid);
      item.selected = false;
    }
  }

  @override
  void dispose() {
    _contentDisplayModeController.close();
    _actionsDisplayModeController.close();
    _scanController.close();
  }

  @override
  void handleError(String message) => _scanController.addError(message);
}

///[RideAttendeeAssignmentContentDisplayMode.LIST] The page is in List mode.
///Here the attendees will be loaded. This can finish with an error or with data.
///The list will use a [FutureBuilder] to show itself.
///[RideAttendeeAssignmentContentDisplayMode.SCAN] The page is in Scan mode.
///[RideAttendeeAssignmentContentDisplayMode.SAVE] The page is saving the selection.
enum RideAttendeeAssignmentContentDisplayMode {
  LIST,
  SCAN,
  SAVE,
}

enum ScanStep {
  LOAD_DEVICES,//-> show loading indicator in the middle + loading devices(in row)
  DO_SCAN,//-> show pulse animation, loading bar and popups
  PROCESS,//show processing + loading indicator in the middle
  DONE//show processing + loading indicator in the middle(we navigate when done anyway)
}