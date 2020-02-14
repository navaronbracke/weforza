
import 'package:weforza/model/device.dart';

///This class defines a bridge between the AddDevice form and the DeviceOverviewPage.
abstract class AddDeviceHandler {
  void onDeviceAdded(Device device);
}