
import 'package:flutter/foundation.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';

abstract class RideAttendeeScanner {
  Stream<ScanStep> startScan(
      VoidCallback onRequestEnableBLE,
      VoidCallback onAlreadyScanning,
      VoidCallback onGenericScanError,
      void Function(int numberOfResults) onScanResultsReceived);

  void stopScan();
}