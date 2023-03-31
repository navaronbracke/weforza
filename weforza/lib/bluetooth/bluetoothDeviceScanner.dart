
import 'package:flutter_blue/flutter_blue.dart';

///This class defines behaviour to scan for bluetooth devices.
abstract class BluetoothDeviceScanner {

  ///Check if bluetooth is enabled.
  ///
  ///Returns true if bluetooth is currently enabled.
  ///Returns false if bluetooth is currently disabled.
  ///Throws an exception if bluetooth is not available on the host device.
  Future<bool> isBluetoothEnabled();

  ///Scan for bluetooth devices.
  ///Has a required scan duration (in seconds).
  ///
  ///Returns a Stream of results.
  ///Each result represents a device name of a device that was found.
  ///Any devices that don't expose their device name are not sent through the stream.
  Stream<String> scanForDevices(int scanDurationInSeconds);

  ///Stop a running scan.
  ///Throws an error if the scan couldn't be stopped.
  Future<void> stopScan();
}

class BluetoothDeviceScannerImpl implements BluetoothDeviceScanner {

  final FlutterBlue _fBlInstance = FlutterBlue.instance;

  @override
  Future<bool> isBluetoothEnabled() => _fBlInstance.isOn;

  @override
  Stream<String> scanForDevices(int scanDurationInSeconds) =>
      _fBlInstance.scan(
          allowDuplicates: false,
          scanMode: ScanMode.balanced,
          timeout: Duration(seconds: scanDurationInSeconds)
      ).where((result) => result?.device?.name != null).map((result) => result.device.name);

  @override
  Future<void> stopScan() => _fBlInstance.stopScan();

}