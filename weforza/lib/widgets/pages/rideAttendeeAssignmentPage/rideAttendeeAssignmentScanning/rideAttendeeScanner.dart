
import 'package:flutter/foundation.dart';
import 'package:weforza/blocs/rideAttendeeAssignmentBloc.dart';

///This contract defines behaviour for scanning with Bluetooth.
abstract class RideAttendeeScanner {
  Stream<ScanStep> get scanStream;

  ///Start a scan.
  ///Returns a [Stream], which can be listened to.
  ///The stream itself doesn't return any data. The actual data is delegated
  Stream<void> startScan(
      VoidCallback onRequestEnableBLE,
      VoidCallback onAlreadyScanning,
      VoidCallback onGenericScanError,
      void Function(int numberOfResults) onScanResultsReceived);

  void stopScan();

  void handleError(String message);
}