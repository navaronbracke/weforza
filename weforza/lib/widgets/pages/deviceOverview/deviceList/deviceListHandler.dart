
import 'package:weforza/model/device.dart';

///This class provides a contract for working with the device list in the device overview screen.
abstract class DeviceListHandler {
  ///Get the list of devices.
  List<Device> get devices;
}