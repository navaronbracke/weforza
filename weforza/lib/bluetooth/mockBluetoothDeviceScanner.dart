
import 'package:weforza/bluetooth/bluetoothDeviceScanner.dart';

class MockBluetoothDeviceScannerImpl implements BluetoothDeviceScanner {
  @override
  Future<bool> isBluetoothEnabled() {
    //fake impl
    return Future.value(true);
  }

  //TODO test with throwing errors (Dart issue needs to be fixed first though)
  @override
  Stream<String> scanForDevices(int scanDurationInSeconds) async* {
    //fake impl that returns some elements
    for(int i = 0; i<4; i++){
      await Future.delayed(Duration(seconds: 2), (){
        //wait 2 seconds
      });
      /*
      *       if(i == 2){
        throw Exception("some error");
      }else{
        yield "Device $i";
      }
      * */
      if(i == 2){
        yield "test";
      }else{
        yield "Device $i";
      }
    }
  }

  @override
  Future<void> stopScan() {
    //Fake impl
    return Future.value(null);
  }

}