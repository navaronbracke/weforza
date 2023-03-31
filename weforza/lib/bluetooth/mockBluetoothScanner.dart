
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';
import 'package:weforza/bluetooth/bluetoothPeripheral.dart';

class MockBluetoothScanner implements BluetoothDeviceScanner {

  /// This flag handles the internal for requesting the scan permission.
  /// This value can be changed for testing.
  bool isPermissionGranted = false;

  @override
  Future<bool> isBluetoothEnabled() {
    return Future.value(true);
  }

  @override
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds) async* {
    for(int i = 0; i< 5; i++){
      await Future.delayed(Duration(seconds: 2),(){});
      if(i == 4){
        yield* Stream.error(Exception("some error"), StackTrace.current);
      }

      if(i == 3){
        yield BluetoothPeripheral(id: "$i", deviceName: "Device Test");
      }

      yield BluetoothPeripheral(id: "$i", deviceName: "Device $i");
    }
  }

  @override
  Future<void> stopScan() {
    return null;
  }

  @override
  void requestScanPermission({void Function() onGranted, void Function() onDenied}) {
    if(isPermissionGranted){
      onGranted();
    }else{
      onDenied();
    }
  }

}