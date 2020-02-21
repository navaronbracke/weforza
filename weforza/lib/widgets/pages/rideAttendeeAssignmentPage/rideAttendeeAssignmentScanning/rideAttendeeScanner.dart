
import 'package:flutter/foundation.dart';

///This contract defines behaviour for scanning with Bluetooth.
abstract class RideAttendeeScanner {

  ///Start a scan.
  ///Takes an [onScanStarted] callback to notify when the scan started.
  ///Takes an [onBluetoothDisabled] callback to request the user to turn on Bluetooth.
  void startScan(VoidCallback onBluetoothDisabled, VoidCallback onScanStarted);

  int scanDuration;

  void stopScan();
}