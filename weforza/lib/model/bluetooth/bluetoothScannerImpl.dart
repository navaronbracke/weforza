
import 'package:flutter_blue/flutter_blue.dart';
import 'package:weforza/model/bluetooth/bluetoothScanner.dart';

///This class implements a production use [IBluetoothScanner].
class BluetoothScannerImpl implements IBluetoothScanner {

  final FlutterBlue _scanner = FlutterBlue.instance;

  @override
  Future<bool> isBluetoothOn() => _scanner.isOn;

  @override
  Stream<String> startScan(ScanMode scanMode, Duration duration)
    => _scanner.scan(scanMode: scanMode,timeout: duration)
        .map((result)=> result?.device?.name);

  @override
  Future<void> stopScan() => _scanner.stopScan();

}