
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
    final BluetoothPeripheral duplicateOwner = BluetoothPeripheral(id: "66", deviceName: "rudy1");
    final BluetoothPeripheral duplicateDevice = BluetoothPeripheral(id: "99", deviceName: "duplicate_device");
    final BluetoothPeripheral ownedByMultiple = BluetoothPeripheral(id: "100", deviceName: "shared1");

    for(int i = 0; i< 10; i++){
      await Future.delayed(Duration(seconds: 2),(){});

      if(i == 4){
        yield* Stream.error(Exception("some error"), StackTrace.current);
      }

      if(i == 2 || i == 9){
        yield duplicateDevice;
      }

      if(i == 5 || i == 7){
        yield duplicateOwner;
      }

      if(i == 3){
        yield ownedByMultiple;
      }

      // Emit unknown devices as fallback.
      yield BluetoothPeripheral(id: "$i", deviceName: "Device $i");
    }
  }

  @override
  Future<void> stopScan() => Future<void>.value(null);

  @override
  void requestScanPermission({void Function() onGranted, void Function() onDenied}) {
    if(isPermissionGranted){
      onGranted();
    }else{
      onDenied();
    }
  }
}