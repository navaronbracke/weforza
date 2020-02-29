
import 'dart:async';
import 'dart:math';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:weforza/model/bluetooth/bluetoothScanner.dart';

///This class implements a testing [IBluetoothScanner].
class MockBluetoothScanner implements IBluetoothScanner {

  ///A [Stopwatch] that will manage the elapsed time
  Stopwatch _timer;
  ///A random results index generator.
  final _rng = Random();

  ///Private cancel flag.
  bool _canceled = false;

  ///Some mock results that will be randomly emitted.
  List<String> _mockResults;

  ///Returns a fake true.
  @override
  Future<bool> isBluetoothOn() => Future<bool>.value(true);

  @override
  Stream<String> startScan(ScanMode scanMode, Duration duration) async* {
    _canceled = false;
    _mockResults = List<String>.generate(5, (index) => "Device Name $index");
    _timer = Stopwatch()..start();
    while(!_canceled || _timer.elapsed.inMilliseconds < duration.inMilliseconds){
      if(_mockResults.isEmpty) break;
      await Future.delayed(Duration(seconds: 2));
      yield _mockResults.removeAt(_rng.nextInt(_mockResults.length));
    }
  }

  @override
  Future<void> stopScan() => Future<void>.value(_canceled = true);
}