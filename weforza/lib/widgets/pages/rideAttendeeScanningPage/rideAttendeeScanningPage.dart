import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/attendeeScanningBloc.dart';
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/scanProcessStep.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelection.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionSubmit.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanPermissionDenied.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/bluetoothDisabled.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/genericScanError.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/preparingScan.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningProgressIndicator.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningStepper.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanResultListItem/scanResultMultiplePossibleOwnersListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanResultListItem/scanResultSingleOwnerListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanResultListItem/scanResultUnknownDeviceListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/skipScanButton.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/unresolvedOwnersList/unresolvedOwnersList.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/unresolvedOwnersList/unresolvedOwnersListItem.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class RideAttendeeScanningPage extends StatefulWidget {
  RideAttendeeScanningPage({
    required this.onRefreshAttendees,
    required this.fileHandler
  });

  final void Function() onRefreshAttendees;
  final IFileHandler fileHandler;

  @override
  _RideAttendeeScanningPageState createState() => _RideAttendeeScanningPageState();
}

class _RideAttendeeScanningPageState extends State<RideAttendeeScanningPage> {

  late AttendeeScanningBloc bloc;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = AttendeeScanningBloc(
      ride: SelectedItemProvider.of(context).selectedRide.value!,
      settingsRepo: InjectionContainer.get<SettingsRepository>(),
      deviceRepo: InjectionContainer.get<DeviceRepository>(),
      memberRepo: InjectionContainer.get<MemberRepository>(),
      scanner: InjectionContainer.get<BluetoothDeviceScanner>(),
      ridesRepo: InjectionContainer.get<RideRepository>(),
    );
    bloc.scanFuture = bloc.startDeviceScan(_onDeviceFound);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIOSLayout(context),
    );
  }

  Widget _buildAndroidLayout(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: RideAttendeeScanningStepper(
          stream: bloc.isScanStep,
        ),
      ),
      body: _buildBody()
    );
  }

  Widget _buildIOSLayout(BuildContext context){
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        automaticallyImplyLeading: false,
        middle: RideAttendeeScanningStepper(
          stream: bloc.isScanStep,
        ),
      ),
      child: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<ScanProcessStep>(
      initialData: ScanProcessStep.INIT,
      stream: bloc.scanStepStream,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Center(child: GenericScanErrorWidget());
        }else{
          switch(snapshot.data){
            case ScanProcessStep.INIT: return Center(child: PreparingScanWidget());
            case ScanProcessStep.BLUETOOTH_DISABLED: return Center(
              child: BluetoothDisabledWidget(
                onGoToSettings: () async => await AppSettings.openBluetoothSettings(),
                onRetryScan: () => bloc.scanFuture = bloc.startDeviceScan(_onDeviceFound),
              ),
            );
            case ScanProcessStep.SCAN:
              return WillPopScope(
                onWillPop: () => bloc.stopScan(),
                child: Column(
                  children: <Widget>[
                    RideAttendeeScanningProgressIndicator(
                      isScanning: bloc.scanning,
                      getDuration: () => bloc.scanDuration,
                    ),
                    Expanded(
                      child: AnimatedList(
                        key: _listKey,
                        itemBuilder: (context, index, animation) {
                          final String deviceName = bloc.getScanResultAt(index);
                          final List<Member> owners = bloc.getDeviceOwners(deviceName);

                          return SizeTransition(
                            sizeFactor: animation,
                            child: _buildScanResultListItem(deviceName, owners),
                          );
                        },
                      ),
                    ),
                    SkipScanButton(
                      isScanning: bloc.scanning,
                      onSkip: () => bloc.skipScan(),
                      onContinue: () => bloc.continueToUnresolvedOwnersList(),
                    ),
                  ],
                ),
              );
            case ScanProcessStep.MANUAL:
              return RideAttendeeManualSelection(
                activeMembersFuture: bloc.loadActiveMembers(),
                itemBuilder: _buildManualSelectionListItem,
                saveButtonBuilder: _buildSaveButton,
              );
            case ScanProcessStep.STOPPING_SCAN: return Center(child: PlatformAwareLoadingIndicator());
            case ScanProcessStep.PERMISSION_DENIED: return Center(child: ScanPermissionDenied());
            case ScanProcessStep.RESOLVE_MULTIPLE_OWNERS: return Center(
              child: UnresolvedOwnersList(
                future: bloc.filterAndSortMultipleOwnersList(),
                itemBuilder: (Member member) => UnresolvedOwnersListItem(
                  firstName: member.firstname,
                  lastName: member.lastname,
                  alias: member.alias,
                  isSelected: () => bloc.isItemSelected(member.uuid),
                  onTap: () => bloc.onMemberSelected(member.uuid),
                ),
                onButtonPressed: () => bloc.continueToManualSelection(),
              ),
            );
            default: return Center(child: GenericScanErrorWidget());
          }
        }
      },
    );
  }

  ///Trigger an insertion for a new item in the AnimatedList.
  void _onDeviceFound(String deviceName){
    if(_listKey.currentState != null){
      bloc.addScanResult(deviceName);
      _listKey.currentState!.insertItem(0);
    }
  }

  void _onSaveScanResults(BuildContext context) async {
    await bloc.saveRideAttendees().then((_){
      widget.onRefreshAttendees();
      Navigator.of(context).pop();
    }).catchError((error){
      //do nothing
    });
  }

  Widget _buildSaveButton(BuildContext context){
    return ManualSelectionSubmit(
      isSaving: bloc.saving,
      onSave: () => _onSaveScanResults(context),
      getAttendeeCount: bloc.getRideAttendeeCount,
      attendeeCountStream: bloc.attendeeCount,
    );
  }

  Widget _buildManualSelectionListItem(Member item){
    return ManualSelectionListItem(
      profileImageFuture: widget.fileHandler.loadProfileImageFromDisk(item.profileImageFilePath),
      firstName: item.firstname,
      lastName: item.lastname,
      alias: item.alias,
      personInitials: item.initials,
      isSelected: () => bloc.isItemSelected(item.uuid),
      onTap: (){
        if(bloc.canSelectMember()){
          bloc.onMemberSelected(item.uuid);
        }
      },
    );
  }

  Widget _buildScanResultListItem(String deviceName, List<Member> owners){
    if(owners.isEmpty){
      return ScanResultUnknownDeviceListItem(deviceName: deviceName);
    }
    if(owners.length == 1){
      return ScanResultSingleOwnerListItem(owner: owners.first);
    }

    return ScanResultMultiplePossibleOwnersListItem(
      deviceName: deviceName,
      amountOfPossibleOwners: owners.length,
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
