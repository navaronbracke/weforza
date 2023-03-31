
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';

class MockBluetoothDeviceScannerImpl implements BluetoothDeviceScanner {
  @override
  Future<bool> isBluetoothEnabled() {
    //fake impl that throws an error or returns true or false
    // TODO: implement isBluetoothEnabled
    return Future.error("fakeBluetoothError");

    //return Future.value(true);
  }

  @override
  Stream<String> scanForDevices(int scanDurationInSeconds) async* {
    //fake impl that returns some elements
    await Future.delayed(Duration(seconds: 2), (){
      //wait 2 seconds
    });
    for(int i = 0; i<5; i++){
      switch(i){
        case 0: yield "Device one";
        break;
        case 1: yield "Device two";
        break;
        case 2: throw Exception("some error");
        break;
        case 3: yield "Device three";
        break;
        case 4: yield "Device four";
        break;
      }

    }
  }

  @override
  Future<void> stopScan() {
    //Fake impl that waits 1 second
    return Future.delayed(Duration(seconds: 1), (){});
  }

}