import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/attendeeScanningBloc.dart';
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/scanResultItem.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/SaveScanOrSkipButton.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/ScanResultListItem.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/bluetoothDisabled.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/genericScanError.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/noMembersForScan.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/preparingScan.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningProgressIndicator.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/rideAttendeeScanningStepper.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

//TODO when the contents were saved (after scan of after manual)
//trigger a reload of the members for this ride in the detail page + set reload rides to true (so the list gets updated)
//we need an attendees container
class RideAttendeeScanningPage extends StatefulWidget {
  @override
  _RideAttendeeScanningPageState createState() => _RideAttendeeScanningPageState(
    AttendeeScanningBloc(
      rideDate: RideProvider.selectedRide.date,
      settingsRepo: InjectionContainer.get<SettingsRepository>(),
      deviceRepo: InjectionContainer.get<DeviceRepository>(),
      memberRepo: InjectionContainer.get<MemberRepository>(),
      scanner: InjectionContainer.get<BluetoothDeviceScanner>(),
      ridesRepo: InjectionContainer.get<RideRepository>(),
    )
  );
}

class _RideAttendeeScanningPageState extends State<RideAttendeeScanningPage> {
  _RideAttendeeScanningPageState(this.bloc): assert(bloc != null);

  final AttendeeScanningBloc bloc;

  final GlobalKey<AnimatedListState> deviceListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
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
          isScanning: bloc.isScanning,
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
          isScanning: bloc.isScanning,
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
                return GenericScanErrorWidget();
              }else{
                switch(snapshot.data){
                  case ScanProcessStep.INIT: return PreparingScanWidget();
                  case ScanProcessStep.BLUETOOTH_DISABLED: return BluetoothDisabledWidget(
                    onGoToSettings: () async => await AppSettings.openBluetoothSettings(),
                    onRetryScan: () => bloc.scanFuture = bloc.retryDeviceScan(_onDeviceFound),
                  );
                  case ScanProcessStep.SCAN:
                    return WillPopScope(
                      onWillPop: () async => bloc.isScanning.value ? await bloc.stopScan() : true,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: AnimatedList(
                              key: deviceListKey,
                              initialItemCount: 0,//Initially we don't have scanned items yet
                              itemBuilder: (BuildContext context, int index, Animation<double> animation){
                                return SizeTransition(
                                  sizeFactor: animation,
                                  child: ScanResultListItem(item: bloc.getScanResultAt(index)),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: SaveScanOrSkipButton(
                                isScanning: bloc.isScanning,
                                onSkip: () => bloc.skipScan(),
                                onSave: () => bloc.saveScanResults(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    break;
                  case ScanProcessStep.MANUAL:
                    //TODO manual selection list -> paged list
                    //TODO save manual selection

                  //present a list + save button (items need to be selectable and have selected state)
                    break;
                  case ScanProcessStep.NO_MEMBERS: return NoMembersForScanWidget();
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
