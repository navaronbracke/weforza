import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/attendeeScanningBloc.dart';
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/scanResultItem.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelection.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/saveScanOrSkipButton.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanResultListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/bluetoothDisabled.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/genericScanError.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/preparingScan.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningProgressIndicator.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningStepper.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class RideAttendeeScanningPage extends StatefulWidget {
  RideAttendeeScanningPage({
    @required this.onRefreshAttendees
  }): assert(onRefreshAttendees != null);

  final void Function() onRefreshAttendees;

  @override
  _RideAttendeeScanningPageState createState() => _RideAttendeeScanningPageState();
}

class _RideAttendeeScanningPageState extends State<RideAttendeeScanningPage> {

  AttendeeScanningBloc bloc;

  final GlobalKey<AnimatedListState> deviceListKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = AttendeeScanningBloc(
      rideDate: SelectedItemProvider.of(context).selectedRide.value.date,
      settingsRepo: InjectionContainer.get<SettingsRepository>(),
      deviceRepo: InjectionContainer.get<DeviceRepository>(),
      memberRepo: InjectionContainer.get<MemberRepository>(),
      scanner: InjectionContainer.get<BluetoothDeviceScanner>(),
      ridesRepo: InjectionContainer.get<RideRepository>(),
    );
    bloc.scanFuture = bloc.doInitialDeviceScan(_onDeviceFound);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: RideAttendeeScanningStepper(
          isScanStep: bloc.isScanStep,
        ),
      ),
      body: _buildBody()
    );
  }

  Widget _buildIOSLayout(BuildContext context){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        automaticallyImplyLeading: false,
        middle: RideAttendeeScanningStepper(
          isScanStep: bloc.isScanStep,
        ),
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        RideAttendeeScanningProgressIndicator(
          valueNotifier: bloc.isScanning,
          //By the time the notifier is triggered, the settings have been loaded.
          //Thus Settings.instance.scanDuration is valid.
          //Therefor by the time this lambda is called, it is safe to access scanDuration.
          getDuration: () => Settings.instance.scanDuration,
        ),
        Expanded(
          child: StreamBuilder<ScanProcessStep>(
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
                      onRetryScan: () => bloc.scanFuture = bloc.retryDeviceScan(_onDeviceFound),
                    ),
                  );
                  case ScanProcessStep.SCAN:
                    return WillPopScope(
                      onWillPop: () => bloc.stopScan(),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: AnimatedList(
                              key: deviceListKey,
                              itemBuilder: (BuildContext context, int index, Animation<double> animation){
                                return SizeTransition(
                                  sizeFactor: animation,
                                  child: ScanResultListItem(
                                      item: bloc.getScanResultAt(index),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: SaveScanOrSkipButton(
                                isSaving: bloc.isSaving,
                                isScanning: bloc.isScanning,
                                onSkip: () => bloc.skipScan(),
                                onSave: () async => await bloc.saveRideAttendees().then((_){
                                  widget.onRefreshAttendees();
                                }, onError: (error){
                                  //do nothing
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  case ScanProcessStep.MANUAL:
                    return RideAttendeeManualSelection(
                        bloc: bloc,
                        onRefreshAttendees: widget.onRefreshAttendees
                    );
                  case ScanProcessStep.STOPPING_SCAN: return Center(child: PlatformAwareLoadingIndicator());
                  default: return Center(child: GenericScanErrorWidget());
                }
              }
            },
          )
        ),
      ],
    );
  }

  ///Trigger an insertion for a new item in the AnimatedList.
  void _onDeviceFound(String deviceName, Future<Member> memberLookup){
    if(deviceListKey.currentState != null){
      bloc.addScanResult(ScanResultItem(deviceName: deviceName, memberLookup: memberLookup));
      deviceListKey.currentState.insertItem(0);
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
