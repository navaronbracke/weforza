
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';

class MockBluetoothDeviceScannerImpl implements BluetoothDeviceScanner {
  @override
  Future<bool> isBluetoothEnabled() {
    //fake impl
    return Future.value(true);
  }

  @override
  Stream<String> scanForDevices(int scanDurationInSeconds) async* {
    //fake impl that returns some elements
    for(int i = 0; i<4; i++){
      await Future.delayed(Duration(seconds: 2), (){
        //wait 2 seconds
      });
      yield "Device $i";
    }
  }

  @override
  Future<void> stopScan() {
    //Fake impl
    return Future.value(null);
  }

}