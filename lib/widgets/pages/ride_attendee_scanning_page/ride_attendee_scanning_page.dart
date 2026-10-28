import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/native_service/bluetooth/bluetooth_adapter_service.dart';
import 'package:weforza/riverpod/repository/device_repository_provider.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/generic_scan_error.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/manual_selection_list.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/ride_attendee_scanning_stepper.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_progress_indicator.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/scan_results_list.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/unresolved_owners_list.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RideAttendeeScanningPage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  RideAttendeeScanningPageState createState() => RideAttendeeScanningPageState();
}

class RideAttendeeScanningPageState extends ConsumerState<RideAttendeeScanningPage>
    with SingleTickerProviderStateMixin {
  late final RideAttendeeScanningDelegate _delegate;

  final GlobalKey<AnimatedListState> _scanResultsKey = GlobalKey();

  AnimationController? _scanProgressBarController;

  StreamSubscription<bool>? _isScanningSubscription;

  Future<void> _startDeviceScan(Settings settings) async {
    _scanProgressBarController?.dispose();
    _scanProgressBarController = AnimationController(
      duration: Duration(seconds: settings.userPreferences.scanDuration),
      vsync: this,
      value: 1.0,
    );

    // Listen to the start signal of the Bluetooth scan,
    // so that the progress bar decreases in progress.
    _isScanningSubscription ??= _delegate.isScanningStream.listen((isScanning) {
      if (_delegate.isDisposed) {
        return;
      }

      // Start decreasing the progress when the scan starts.
      // Every scan restarts from a full bar, as a previous scan leaves the controller at (or near) zero.
      if (isScanning) {
        _scanProgressBarController?.reverse(from: 1.0);
      }
    });

    return _delegate.startDeviceScan(
      scanSettings: (settings.userPreferences.scanDuration, settings.excludedTermsFilter),
    );
  }

  @override
  void initState() {
    super.initState();

    _delegate = RideAttendeeScanningDelegate(
      deviceRepository: ref.read(deviceRepositoryProvider),
      riderRepository: ref.read(riderRepositoryProvider),
      ride: ref.read(selectedRideProvider)!,
      rideRepository: ref.read(rideRepositoryProvider),
      // The underlying BluetoothAdapterService uses its own state,
      // which is disposed when this page is unmounted.
      scanner: BluetoothAdapterService(),
      // The delegate will have added the device to the scan results,
      // the only thing left to do is to insert it into the animated list.
      onDeviceFound: (device) => _scanResultsKey.currentState?.insertItem(0),
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: RideAttendeeScanningStepper(listenable: _delegate.scanningStateListenable)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder<AsyncValue<RideAttendeeScanningState>>(
      valueListenable: _delegate.scanningStateListenable,
      builder: (context, currentValue, _) {
        if (currentValue case AsyncData(:final value)) {
          return switch (value) {
            .bluetoothDisabled => Center(child: BluetoothDisabledError(onRetry: _delegate.startDeviceScan)),
            .manualSelection => ManualSelectionList(delegate: _delegate),
            .permissionDenied => const Center(child: PermissionDeniedError()),
            .initializing ||
            .requestPermissions ||
            .startingScan ||
            .stoppingScan => const Center(child: PlatformAwareLoadingIndicator()),
            .scanning => ScanResultsList(
              delegate: _delegate,
              progressBar: ScanProgressIndicator(
                isScanning: _delegate.isScanning,
                isScanningStream: _delegate.isScanningStream,
                scanTimerAnimation: _scanProgressBarController?.view ?? const AlwaysStoppedAnimation<double>(1.0),
              ),
              scanResultsListKey: _scanResultsKey,
            ),
            .unresolvedOwnersSelection => UnresolvedOwnersList(delegate: _delegate),
          };
        }

        return const Center(child: GenericScanError());
      },
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: RideAttendeeScanningStepper(listenable: _delegate.scanningStateListenable),
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
    ref.listen(settingsProvider, (_, settings) {
      if (_delegate.hasLoadedScanSettings) {
        return;
      }

      switch (settings) {
        case AsyncLoading<Settings>():
          // Wait for the settings to be loaded.
          return;
        case AsyncData<Settings>(:final value):
          unawaited(_startDeviceScan(value));

          return;
        case AsyncError<Settings>():
        // Do not provide the delegate with scan settings if they are not available.
        // Cached settings will be used anyway, and the delegate will show a scan error if none are available.
      }
    });

    return PopScope<Object?>(
      // The `canPop` parameter is always true,
      // since leaving the page should just stop a running scan.
      onPopInvokedWithResult: (bool didPop, _) async {
        // The page was left by popping the route,
        // stop the scan if it's still running.
        if (didPop) {
          await _delegate.stopScan();
        }
      },
      child: PlatformAwareWidget(android: _buildAndroidLayout, ios: _buildIOSLayout),
    );
  }

  @override
  void dispose() {
    unawaited(_isScanningSubscription?.cancel());
    unawaited(_delegate.dispose());
    _scanProgressBarController?.dispose();
    super.dispose();
  }
}
