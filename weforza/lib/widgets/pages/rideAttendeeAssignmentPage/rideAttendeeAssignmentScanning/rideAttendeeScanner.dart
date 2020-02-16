
import 'package:flutter/foundation.dart';

abstract class RideAttendeeScanner {
  Stream<void> startScan(
      VoidCallback onRequestEnableBLE,
      VoidCallback onAlreadyScanning,
      VoidCallback onGenericScanError,
      void Function(int numberOfResults) onScanResultsReceived);

  void stopScan();
}