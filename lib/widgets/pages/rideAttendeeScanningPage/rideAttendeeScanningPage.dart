import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/attendee_scanning_bloc.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/rideAttendeeScanResult.dart';
import 'package:weforza/model/scanProcessStep.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/bluetoothDisabled.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/genericScanError.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelection.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionSubmit.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/preparingScan.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningProgressIndicator.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningStepper.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanPermissionDenied.dart';
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
  const RideAttendeeScanningPage({
    Key? key,
    required this.onRefreshAttendees,
    required this.fileHandler,
  }) : super(key: key);

  final void Function() onRefreshAttendees;
  final IFileHandler fileHandler;

  @override
  _RideAttendeeScanningPageState createState() =>
      _RideAttendeeScanningPageState();
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

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: RideAttendeeScanningStepper(
            stream: bloc.isScanStep,
          ),
        ),
        body: _buildBody());
  }

  Widget _buildIOSLayout(BuildContext context) {
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
        // We need the bottom view padding for the manual selection save widget.
        bottom: false,
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<ScanProcessStep>(
      initialData: ScanProcessStep.INIT,
      stream: bloc.scanStepStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: GenericScanErrorWidget());
        } else {
          switch (snapshot.data) {
            case ScanProcessStep.INIT:
              return const Center(child: PreparingScanWidget());
            case ScanProcessStep.BLUETOOTH_DISABLED:
              return Center(
                child: BluetoothDisabledWidget(
                  onGoToSettings: () async =>
                      await AppSettings.openBluetoothSettings(),
                  onRetryScan: () =>
                      bloc.scanFuture = bloc.startDeviceScan(_onDeviceFound),
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
                          final List<Member> owners =
                              bloc.getDeviceOwners(deviceName);

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
                isMemberScanned: bloc.isMemberScanned,
                activeMembersFuture: bloc.loadActiveMembers(),
                itemBuilder: _buildManualSelectionListItem,
                saveButtonBuilder: _buildSaveButton,
                query: bloc.searchQuery,
                showScanned: bloc.showScanned,
                onShowScannedChanged: bloc.onShowScannedChanged,
                onQueryChanged: bloc.onQueryChanged,
              );
            case ScanProcessStep.STOPPING_SCAN:
              return const Center(child: PlatformAwareLoadingIndicator());
            case ScanProcessStep.PERMISSION_DENIED:
              return const Center(child: ScanPermissionDenied());
            case ScanProcessStep.RESOLVE_MULTIPLE_OWNERS:
              return Center(
                child: UnresolvedOwnersList(
                  future: bloc.filterAndSortMultipleOwnersList(),
                  itemBuilder: (Member member) {
                    // For UnresolvedOwnersListItem's isScanned is false anyway.
                    final attendeeScanResult = RideAttendeeScanResult(
                        uuid: member.uuid, isScanned: false);

                    return UnresolvedOwnersListItem(
                      firstName: member.firstname,
                      lastName: member.lastname,
                      alias: member.alias,
                      isSelected: () => bloc.isItemSelected(attendeeScanResult),
                      // We should not show dialogs on this screen.
                      // We have to select manually anyway.
                      onTap: () =>
                          bloc.onMemberSelectedWithoutConfirmationDialog(
                              attendeeScanResult),
                    );
                  },
                  onButtonPressed: () => bloc.continueToManualSelection(),
                ),
              );
            default:
              return const Center(child: GenericScanErrorWidget());
          }
        }
      },
    );
  }

  ///Trigger an insertion for a new item in the AnimatedList.
  void _onDeviceFound(String deviceName) {
    if (_listKey.currentState != null) {
      bloc.addAutomaticScanResult(deviceName);
      _listKey.currentState!.insertItem(0);
    }
  }

  Future<void> _onSaveScanResults(BuildContext context) async {
    // Errors from this future are caught
    // by the FutureBuilder that consumes this method.
    return await bloc.saveRideAttendees().then((_) {
      widget.onRefreshAttendees();
      Navigator.of(context).pop();
    });
  }

  Widget _buildSaveButton(BuildContext context) {
    return ManualSelectionSubmit(
      attendeeCount: bloc.attendeeCount,
      initialAttendeeCount: bloc.rideAttendeeCount,
      showScanned: bloc.showScanned,
      onShowScannedChanged: bloc.onShowScannedChanged,
      save: () => _onSaveScanResults(context),
    );
  }

  Widget _buildManualSelectionListItem(Member item, bool isScanned) {
    return ManualSelectionListItem(
      profileImageFuture: widget.fileHandler
          .loadProfileImageFromDisk(item.profileImageFilePath),
      firstName: item.firstname,
      lastName: item.lastname,
      alias: item.alias,
      personInitials: item.initials,
      isScanned: () => bloc.isMemberScanned(item.uuid),
      isSelected: () => bloc.isItemSelected(
        RideAttendeeScanResult(
          uuid: item.uuid,
          isScanned: isScanned,
        ),
      ),
      uuid: item.uuid,
      canTap: () => bloc.canSelectMember,
      addScanResult: bloc.addManualScanResult,
      removeScanResult: bloc.removeScanResult,
      scanResultExists: bloc.scanResultExists,
    );
  }

  Widget _buildScanResultListItem(String deviceName, List<Member> owners) {
    if (owners.isEmpty) {
      return ScanResultUnknownDeviceListItem(deviceName: deviceName);
    }
    if (owners.length == 1) {
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
