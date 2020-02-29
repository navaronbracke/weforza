

import 'package:flutter_blue/flutter_blue.dart';

///This class defines a contract for a bluetooth scanner.
abstract class IBluetoothScanner {

  ///Check if bluetooth is on.
  Future<bool> isBluetoothOn();

  ///Stop a scan.
  Future<void> stopScan();

  ///Start a scan. Returns a [Stream] of [ScanResult]s found while scanning.
  ///Uses [scanMode] to determine the type of scan, e.g. [ScanMode.lowPower].
  ///The scan will stop after [duration].
  Stream<ScanResult> startScan(ScanMode scanMode, Duration duration);
}