
import 'package:weforza/model/device.dart';
import 'package:weforza/provider/memberProvider.dart';

///This class provides a global container for the [Device]s of selectedMember
///in [MemberProvider] and a reload flag for loading [Device]s from a datasource.
class DeviceProvider {

  //Whether we have to reload the devices or not.
  static bool reloadDevices = true;

  ///The [Device]s of the selected member.
  static List<Device> selectedMemberDevices;
}