import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
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
  RideAttendeeScanningPageState createState() =>
      RideAttendeeScanningPageState();
}

class RideAttendeeScanningPageState
    extends ConsumerState<RideAttendeeScanningPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanProgressBarController;

  final GlobalKey<AnimatedListState> _scanResultsKey = GlobalKey();

  StreamSubscription<bool>? _startScanningSubscription;

  late final RideAttendeeScanningDelegate delegate;

  @override
  void initState() {
    super.initState();

    delegate = RideAttendeeScanningDelegate(
      // The delegate will have added the device to the scan results,
      // the only thing left to do is to inset it into the animated list.
      onDeviceFound: (device) => _scanResultsKey.currentState?.insertItem(0),
      ref: ref,
    );

    _scanProgressBarController = AnimationController(
      duration: Duration(seconds: delegate.settings.scanDuration),
      vsync: this,
      value: 1.0,
    );

    // Setup a subscription that listens to the start of the device scan
    // and starts the progress animation.
    _startScanningSubscription = delegate.scanner.isScanning.listen((value) {
      // If the subscription is null, the stream is or will be disposed.
      if (_startScanningSubscription == null || !value) {
        return;
      }

      // Start the animation when the scan stream emits the event
      // that indicates that the scan started.
      // The animation starts with a filled progress bar.
      if (_scanProgressBarController.status == AnimationStatus.completed) {
        _scanProgressBarController.reverse();
      }
    });

    delegate.startDeviceScan();
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: RideAttendeeScanningStepper(stream: delegate.stateStream),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<RideAttendeeScanningState>(
      stream: delegate.stateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (snapshot.hasError || state == null) {
          return const Center(child: GenericScanError());
        }

        switch (state) {
          case RideAttendeeScanningState.bluetoothDisabled:
            return Center(
              child: BluetoothDisabledError(onRetry: delegate.startDeviceScan),
            );
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
        automaticallyImplyLeading: false,
        middle: RideAttendeeScanningStepper(stream: delegate.stateStream),
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
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIOSLayout(context),
    );
  }

  @override
  void dispose() {
    _startScanningSubscription?.cancel();
    _startScanningSubscription = null;
    _scanProgressBarController.dispose();
    delegate.dispose();
    super.dispose();
  }
}
