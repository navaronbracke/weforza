import 'package:weforza/model/rider/rider.dart';

/// This class represents a device that was found during a Bluetooth scan.
class ScannedDevice {
  const ScannedDevice(this.name, this.owners);

  /// The name of the scanned device.
  final String name;

  /// The possible owners of the scanned device.
  final List<Member> owners;
}
