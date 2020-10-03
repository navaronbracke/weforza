
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
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

  ///Check the required permission for starting a scan.
  ///When the permission is unknown, it is requested first.
  ///After requesting the permission, the proper callback is called.
  ///When the permission was granted before [onGranted] gets called.
  ///When the permission is denied, [onDenied] gets called.
  void requestScanPermission({void Function() onGranted, void Function() onDenied});
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
      ).map((result){
        if(result == null || result.device == null) return null;

        return BluetoothPeripheral(id: result.device.id.id, deviceName: result.device.name);
      });

  @override
  Future<void> stopScan() => _fBlInstance.stopScan();

  @override
  void requestScanPermission({void Function() onGranted, void Function() onDenied}) async {
    if(await Permission.locationWhenInUse.request().isGranted){
      onGranted();
    }else{
      onDenied();
    }
  }

}