
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentItemBloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/model/rideAttendee.dart';
import 'package:weforza/model/rideAttendeeSelector.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentList/rideAttendeeAssignmentList.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeScanner.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeNavigationBarDisplayMode.dart';

class RideAttendeeAssignmentBloc extends Bloc implements RideAttendeeSelector,RideAttendeeScanner, RideAttendeeAssignmentInitializer {
  RideAttendeeAssignmentBloc(this.ride,this._rideRepository,this._memberRepository,this._deviceRepository):
        assert(ride != null && _memberRepository != null && _rideRepository != null && _deviceRepository != null);

  ///The [Ride] for which to change the attendees.
  final Ride ride;
  final RideRepository _rideRepository;
  final MemberRepository _memberRepository;
  final DeviceRepository _deviceRepository;

  bool _membersLoaded = false;
  Future<List<RideAttendeeAssignmentItemBloc>> _loadMembersFuture;

  ///The [FlutterBlue] instance that will handle the scanning.
  final FlutterBlue bluetoothScanner = FlutterBlue.instance;

  ///Whether the scan is cancelled
  bool isCanceled = false;

  Future<void> scanFuture;

  @override
  int scanDuration = 20;

  ///A Map containing the device names that were found and whether they have duplicates
  Map<String,bool> scannedDevices;

  ///The members contain the fully loaded [MemberItem]s and their selection state.
  ///They are stored here so the scanning widget won't have to reload the members during its init step.
  ///This way it only needs to load the devices and put both the members and devices into their respective Map.
  ///The key is the member id.
  Map<String,RideAttendeeAssignmentItemBloc> members;

  ///The devices of all members are stored here.
  ///The key is the device name.
  ///The value is the ID of the member.
  Map<String,String> devices;

  ///This [BehaviorSubject] controls the visibility of elements for the ride attendee assignment page.
  final StreamController<RideAttendeeNavigationBarDisplayMode> _navigationBarDisplayMode = BehaviorSubject();
  Stream<RideAttendeeNavigationBarDisplayMode> get navigationBarStream => _navigationBarDisplayMode.stream;

  ///This [BehaviorSubject] controls the found devices popup data.
  final StreamController<String> _foundDevicesStream = BehaviorSubject();
  Stream<String> get foundDevices => _foundDevicesStream.stream;

  ///This [BehaviorSubject] controls what content page is shown.
  final StreamController<RideAttendeeAssignmentContentDisplayMode> _contentDisplayModeController = BehaviorSubject();
  Stream<RideAttendeeAssignmentContentDisplayMode> get contentDisplayModeStream => _contentDisplayModeController.stream;

  ///The UUID's of the [Member]s that should be saved as Attendees of [ride] on submit.
  List<String> scannedAttendees;

  Future<List<RideAttendeeAssignmentItemBloc>> _loadMembers() async {
    final itemsFromDb = await _memberRepository.getMembers();
    members = {};
    scannedAttendees = List();
    scannedDevices = {};
    if(itemsFromDb.isNotEmpty){
      //Load the attendee ID's of the current attendees
      final attendees = await _memberRepository.getRideAttendeeIds(ride.date);
      await Future.wait(itemsFromDb.map((member)=> _mapMemberToItem(member,attendees.contains(member.uuid))));

      if(members.keys.isNotEmpty){
        _navigationBarDisplayMode.add(RideAttendeeNavigationBarDisplayMode.LIST_ACTIONS);
      }
      _membersLoaded = true;
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
      scannedAttendees.add(item.member.uuid);
    }
    members.putIfAbsent(item.member.uuid, ()=> item);
  }

  Future<void> onSubmit() async {
    _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.SAVE);
    _navigationBarDisplayMode.add(RideAttendeeNavigationBarDisplayMode.LIST_NO_ACTIONS);
    await _rideRepository.updateAttendeesForRideWithDate(ride, scannedAttendees.map(
            (uuid)=> RideAttendee(ride.date,uuid)).toList()
    ).then((_){
      RideProvider.reloadRides = true;
      RideProvider.selectedRide = ride;
    });
  }


  ///Load the devices to scan for when a scan is started.
  Future<void> _loadDevicesToScanFor() async {
    if(devices == null){
      //TODO load the scan duration from sembast, set the default to zero
      devices = {};
      final items = await _deviceRepository.getAllDevices();
      items.forEach((device){
        devices.putIfAbsent(device.name, () => device.ownerId);
      });
    }
  }

  ///Process [scannedDevices] .
  ///Eliminate duplicates and notify the owners.
  void _processResults(){
    //remove the duplicates
    scannedDevices.removeWhere((key,value)=> value == true);
    scannedDevices.keys.forEach((deviceName){
      final owner = members[devices[deviceName]];
      if(owner != null && owner.selected == false){
        select(owner);
      }
    });
  }

  @override
  void stopScan() async {
    if(await bluetoothScanner.isScanning.first){
      isCanceled = true;
      scanFuture = null;
      await bluetoothScanner.stopScan().then((_) async {
        _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.PROCESS);
        _processResults();
        _returnToList();
      }).catchError((e) => _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.ERR_GENERIC));
      isCanceled = false;
    }
  }

  @override
  void startScan(VoidCallback onBluetoothDisabled, VoidCallback onScanStarted) async {
    await bluetoothScanner.isOn.then((isOn){
      if(isOn){
        _navigationBarDisplayMode.add(RideAttendeeNavigationBarDisplayMode.SCAN);
        _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.LOAD_DEVICES);
        scanFuture = _loadDevicesToScanFor().then((_) async {
          _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.SCAN);
          onScanStarted();
          await for(ScanResult result in bluetoothScanner.scan(scanMode: ScanMode.balanced,timeout: Duration(seconds: scanDuration))){
            if(isCanceled) break;
            final deviceName = result.device.name;
            //only allow known devices to be used
            if(devices.keys.contains(deviceName)){
              //Lookup a possible value
              //if not found(no duplicates yet), add it with false otherwise set it to true
              scannedDevices[deviceName] = scannedDevices[deviceName] != null;
              if(!scannedDevices[deviceName]){
                _foundDevicesStream.add(deviceName);
              }
            }
          }
          _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.PROCESS);
          _processResults();
          _returnToList();
        }).catchError((e) => _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.ERR_GENERIC));
      }else{
        onBluetoothDisabled();
      }
    }).catchError((e) => _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.ERR_GENERIC));
  }

  ///Return to the attendee list overview
  void _returnToList(){
    if(members.keys.isNotEmpty){
      _navigationBarDisplayMode.add(
          RideAttendeeNavigationBarDisplayMode.LIST_ACTIONS
      );
    }
    _contentDisplayModeController.add(RideAttendeeAssignmentContentDisplayMode.LIST);
  }

  @override
  void select(RideAttendeeAssignmentItemBloc item) {
    if(!scannedAttendees.contains(item.member.uuid)){
      scannedAttendees.add(item.member.uuid);
      item.selected = true;
    }
  }

  @override
  void unSelect(RideAttendeeAssignmentItemBloc item) {
    if(scannedAttendees.contains(item.member.uuid)){
      scannedAttendees.remove(item.member.uuid);
      item.selected = false;
    }
  }

  @override
  void dispose() {
    _contentDisplayModeController.close();
    _navigationBarDisplayMode.close();
    _foundDevicesStream.close();
    scanFuture = null;
  }

  @override
  bool get isMembersLoaded => _membersLoaded;

  @override
  Future<List<RideAttendeeAssignmentItemBloc>> get loadMembersFuture {
    if(_loadMembersFuture == null){
      _loadMembersFuture = _loadMembers();
    }
    return _loadMembersFuture;
  }

  @override
  List<RideAttendeeAssignmentItemBloc> get loadedData => members.values.toList();
}

enum RideAttendeeAssignmentContentDisplayMode {
  LIST,
  LOAD_DEVICES,
  SCAN,
  PROCESS,
  SAVE,
  ERR_ALREADY_SCANNING,
  ERR_GENERIC
}