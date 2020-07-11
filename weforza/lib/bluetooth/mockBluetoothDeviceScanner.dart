
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
    for(int i = 0; i<5; i++){
      switch(i){
        case 0: {
          await Future.delayed(Duration(seconds: 2), (){
            //wait 2 seconds
          });
        }
        yield "Device one";
        break;
        case 1: {
          await Future.delayed(Duration(seconds: 2), (){
            //wait 2 seconds
          });
        }
        yield "Device two";
        break;
        case 2: {
          await Future.delayed(Duration(seconds: 2), (){
            //wait 2 seconds
          });
        }
        throw Exception("some error");
        break;
        case 3: {
          await Future.delayed(Duration(seconds: 2), (){
            //wait 2 seconds
          });
        } yield "Device three";
        break;
        case 4: {
          await Future.delayed(Duration(seconds: 2), (){
            //wait 2 seconds
          });
        } yield "Device four";
        break;
      }

    }
  }

  @override
  Future<void> stopScan() {
    //Fake impl
    return Future.value(null);
  }

}