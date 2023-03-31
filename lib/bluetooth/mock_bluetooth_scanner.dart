import 'package:rxdart/rxdart.dart';
import 'package:weforza/bluetooth/bluetooth_device_scanner.dart';
import 'package:weforza/bluetooth/bluetooth_peripheral.dart';

class MockBluetoothScanner implements BluetoothDeviceScanner {
  final _scanningController = BehaviorSubject.seeded(false);

  final PublishSubject _stopScanPill = PublishSubject();

  /// Build a fake scan results stream.
  Stream<BluetoothPeripheral> _buildScanResultsStream() async* {
    final duplicateOwner = BluetoothPeripheral(id: '1', deviceName: 'rudy1');
    final duplicateDevice = BluetoothPeripheral(
      id: '2',
      deviceName: 'duplicate_device',
    );
    final ownedByMultiple = BluetoothPeripheral(id: '3', deviceName: 'shared1');
    final emptyDeviceName = BluetoothPeripheral(id: '4', deviceName: '');
    final blankDeviceName = BluetoothPeripheral(id: '5', deviceName: '  ');

    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(seconds: 2));

      if (i == 1) {
        yield* Stream.error(ArgumentError('some error'), StackTrace.current);
      }

      if (i == 2 || i == 3) {
        yield duplicateDevice;
      }

      if (i == 4 || i == 5) {
        yield duplicateOwner;
      }

      if (i == 6) {
        yield ownedByMultiple;
      }

      if (i == 7) {
        yield emptyDeviceName;
      }

      if (i == 8) {
        yield blankDeviceName;
      }

      // Emit unknown devices as fallback.
      yield BluetoothPeripheral(id: '$i', deviceName: 'Device $i');
    }
  }

  @override
  Future<bool> isBluetoothEnabled() async => true;

  @override
  Stream<bool> get isScanning => _scanningController;

  @override
  Stream<BluetoothPeripheral> scanForDevices(int scanDurationInSeconds) {
    if (_scanningController.value) {
      throw Exception('Another scan is already in progress.');
    }

    _scanningController.add(true);

    final killStreams = <Stream>[
      _stopScanPill,
      Rx.timer(null, Duration(seconds: scanDurationInSeconds)),
    ];

    return _buildScanResultsStream().takeUntil(Rx.merge(killStreams)).doOnDone(stopScan);
  }

  @override
  Future<void> stopScan() async {
    if (!_scanningController.isClosed) {
      _stopScanPill.add(null);
      _scanningController.add(false);
    }
  }

  @override
  void dispose() {
    _stopScanPill.close();
    _scanningController.close();
  }
}
