import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/riverpod/repository/device_repository_provider.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/riverpod/settings_provider.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/generic_scan_error.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/manual_selection_list.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/ride_attendee_scanning_stepper.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_progress_indicator.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_results_list.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/unresolved_owners_list.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RideAttendeeScanningPage extends ConsumerStatefulWidget {
  const RideAttendeeScanningPage({super.key});

  @override
  RideAttendeeScanningPageState createState() => RideAttendeeScanningPageState();
}

class RideAttendeeScanningPageState extends ConsumerState<RideAttendeeScanningPage>
    with SingleTickerProviderStateMixin {
  late final RideAttendeeScanningDelegate delegate;

  final GlobalKey<AnimatedListState> _scanResultsKey = GlobalKey();

  late final AnimationController _scanProgressBarController;

  /// The subscription that listens to the start of the Bluetooth scan.
  StreamSubscription<bool>? _startScanningSubscription;

  /// Listen to the start signal of the Bluetooth scan
  /// and start decreasing the progress in the progress bar.
  void _listenToScanStart(bool isScanning) {
    if (delegate.isDisposed || !isScanning) {
      return;
    }

    // Start decreasing the progress when the scan starts.
    if (_scanProgressBarController.status == AnimationStatus.completed) {
      _scanProgressBarController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();

    final settings = ref.read(settingsProvider);

    _scanProgressBarController = AnimationController(
      duration: Duration(seconds: settings.scanDuration),
      vsync: this,
      value: 1.0,
    );

    delegate = RideAttendeeScanningDelegate(
      deviceRepository: ref.read(deviceRepositoryProvider),
      riderRepository: ref.read(riderRepositoryProvider),
      ride: ref.read(selectedRideProvider)!,
      rideRepository: ref.read(rideRepositoryProvider),
      settings: settings,
      // The delegate will have added the device to the scan results,
      // the only thing left to do is to insert it into the animated list.
      onDeviceFound: (device) => _scanResultsKey.currentState?.insertItem(0),
    );

    // Listen to the start signal of the Bluetooth scan,
    // so that the progress bar decrease in progress.
    _startScanningSubscription = delegate.scanner.isScanningStream.listen(_listenToScanStart);

    delegate.startDeviceScan();
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: RideAttendeeScanningStepper(
          initialData: delegate.currentState,
          stream: delegate.stream,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<RideAttendeeScanningState>(
      initialData: delegate.currentState,
      stream: delegate.stream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (snapshot.hasError || state == null) {
          return const Center(child: GenericScanError());
        }

        switch (state) {
          case RideAttendeeScanningState.bluetoothDisabled:
            return Center(child: BluetoothDisabledError(onRetry: delegate.startDeviceScan));
          case RideAttendeeScanningState.manualSelection:
            return ManualSelectionList(delegate: delegate);
          case RideAttendeeScanningState.permissionDenied:
            return const Center(child: PermissionDeniedError());
          case RideAttendeeScanningState.requestPermissions:
          case RideAttendeeScanningState.startingScan:
          case RideAttendeeScanningState.stoppingScan:
            return const Center(child: PlatformAwareLoadingIndicator());
          case RideAttendeeScanningState.scanning:
            return ScanResultsList(
              delegate: delegate,
              progressBar: ScanProgressIndicator(
                animationController: _scanProgressBarController,
                isScanning: delegate.scanner.isScanning,
                isScanningStream: delegate.scanner.isScanningStream,
              ),
              scanResultsListKey: _scanResultsKey,
            );
          case RideAttendeeScanningState.unresolvedOwnersSelection:
            return UnresolvedOwnersList(delegate: delegate);
        }
      },
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: RideAttendeeScanningStepper(
          initialData: delegate.currentState,
          stream: delegate.stream,
        ),
      ),
      child: SafeArea(
        // The bottom view padding should be preserved
        // for the manual selection save widget,
        bottom: false,
        child: _buildBody(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // The `canPop` parameter is always true,
      // since leaving the page should just stop a running scan.
      onPopInvoked: (bool didPop) async {
        // The page was left by popping the route,
        // stop the scan if it's still running.
        if (didPop) {
          await delegate.stopScan();
        }
      },
      child: PlatformAwareWidget(
        android: _buildAndroidLayout,
        ios: _buildIOSLayout,
      ),
    );
  }

  @override
  Future<void> dispose() async {
    // Dispose the animation controller, and the widget first.
    // Only then dispose the delegate.
    _scanProgressBarController.dispose();
    super.dispose();

    await _startScanningSubscription?.cancel();
    await delegate.dispose();
  }
}
