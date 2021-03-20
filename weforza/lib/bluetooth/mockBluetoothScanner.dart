
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';
import 'package:weforza/bluetooth/bluetoothPeripheral.dart';

class MockBluetoothScanner implements BluetoothDeviceScanner {

  /// This flag handles the internal for requesting the scan permission.
  /// This value can be changed for testing.
  bool isPermissionGranted = true;

  @override
  Future<bool> isBluetoothEnabled() {
    return Future.value(true);
  }

  @override
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds) async* {
    final BluetoothPeripheral duplicateOwner = BluetoothPeripheral(id: "1", deviceName: "rudy1");
    final BluetoothPeripheral duplicateDevice = BluetoothPeripheral(id: "2", deviceName: "duplicate_device");
    final BluetoothPeripheral ownedByMultiple = BluetoothPeripheral(id: "3", deviceName: "shared1");
    final BluetoothPeripheral emptyDeviceName = BluetoothPeripheral(id: "4", deviceName: "");
    final BluetoothPeripheral blankDeviceName = BluetoothPeripheral(id: "5", deviceName: "  ");

    for(int i = 0; i< 10; i++){
      await Future.delayed(Duration(seconds: 2),(){});

      if(i == 1){
        yield* Stream.error(Exception("some error"), StackTrace.current);
      }

      if(i == 2 || i == 3){
        yield duplicateDevice;
      }

      if(i == 4 || i == 5){
        yield duplicateOwner;
      }

      if(i == 6){
        yield ownedByMultiple;
      }

      if(i == 7){
        yield emptyDeviceName;
      }

      if(i == 8){
        yield blankDeviceName;
      }

      // Emit unknown devices as fallback.
      yield BluetoothPeripheral(id: "$i", deviceName: "Device $i");
    }
  }

  @override
  Future<void> stopScan() => Future<void>.value(null);

  @override
  void requestScanPermission({required void Function() onGranted, required void Function() onDenied}) {
    if(isPermissionGranted){
      onGranted();
    }else{
      onDenied();
    }
  }
}