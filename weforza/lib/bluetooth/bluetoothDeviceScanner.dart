
import 'package:flutter_blue/flutter_blue.dart';
import 'package:weforza/bluetooth/bluetoothPeripheral.dart';

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

  final FlutterBlue _fBlInstance = FlutterBlue.instance;

  @override
  Future<bool> isBluetoothEnabled() => _fBlInstance.isOn;

  @override
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds) =>
      _fBlInstance.scan(
          allowDuplicates: false,
          scanMode: ScanMode.balanced,
          timeout: Duration(seconds: scanDurationInSeconds)
      ).where((ScanResult result) => result?.device?.name != null).map((result) => BluetoothPeripheral(
        id: result.device.id.id,//result.device.id = DeviceIdentifier
        deviceName: result.device.name
      ));

  @override
  Future<void> stopScan() => _fBlInstance.stopScan();

}