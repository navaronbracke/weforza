import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';

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
  ///Each result represents a device that was found with an id + name.
  ///Any devices that don't expose their device name are not sent through the stream.
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds);

  ///Stop a running scan.
  ///Throws an error if the scan couldn't be stopped.
  Future<void> stopScan();
}

class BluetoothDeviceScannerImpl implements BluetoothDeviceScanner {
  final FlutterBluePlus _fBlInstance = FlutterBluePlus.instance;

  @override
  Future<bool> isBluetoothEnabled() => _fBlInstance.isOn;

  @override
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds) =>
      _fBlInstance
          .scan(
            allowDuplicates: false,
            scanMode: ScanMode.balanced,
            timeout: Duration(seconds: scanDurationInSeconds),
          )
          .map(
            (result) => BluetoothPeripheral(
              id: result.device.id.id,
              // Trim the whitespace off.
              // This could otherwise cause matching issues later on.
              deviceName: result.device.name.trim(),
            ),
          );

  @override
  Future<void> stopScan() => _fBlInstance.stopScan();
}
